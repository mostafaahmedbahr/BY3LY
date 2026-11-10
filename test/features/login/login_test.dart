import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/app_services/local_services/cache_token.dart';
import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/login/data/models/login_model.dart';
import 'package:by3ly/features/login/data/repos/login_repos_imple.dart';
import 'package:by3ly/features/login/presentation/view_model/login_cubit.dart';
import 'package:by3ly/features/login/presentation/view_model/login_states.dart';
import 'package:by3ly/features/login/presentation/views/login_view.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeLoginRepo extends LoginRepoImpl {
  FakeLoginRepo({
    this.shouldFail = false,
    this.isActive = true,
    this.status = true,
    this.message = 'ok',
    this.requiresOtp = true,
  }) : super(null);

  final bool shouldFail;
  final bool isActive;
  final bool status;
  final String message;
  final bool requiresOtp;

  int calls = 0;
  Map<String, String?>? lastPayload;

  @override
  Future<Either<Failure, LoginModel>> login({
    required String phone,
    required String password,
    required String deviceToken,
  }) async {
    calls++;
    lastPayload = {'phone': phone, 'password': password, 'deviceToken': deviceToken};
    if (shouldFail) return Left(ServerFailure('offline'));
    return Right(LoginModel.fromJson({
      'status': status,
      'message': message,
      'data': {
        'isActive': isActive,
        'requires_otp': requiresOtp,
        'user': {
          'id': 5,
          'name': 'Ahmed',
          'email': 'a@b.com',
          'phone': phone,
          'token': 'tok-1',
        },
      },
    }));
  }
}

Widget _testApp() {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, _) => EasyLocalization(
      startLocale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: Builder(
        builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: const LoginView(),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
    await EasyLocalization.ensureInitialized();
    const secureChannel =
        MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureChannel, (call) async => null);
  });

  setUp(() {
    CacheTokenManger.userToken = null;
  });

  tearDown(() async {
    if (getIt.isRegistered<LoginRepoImpl>()) {
      await getIt.unregister<LoginRepoImpl>();
    }
    CacheTokenManger.userToken = null;
  });

  group('LoginModel parsing', () {
    test('full envelope parses (status variants included)', () {
      final model = LoginModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'isActive': true,
          'requires_otp': false,
          'user': {'id': 5, 'name': 'Ahmed', 'token': 'tok-1'},
        },
      });
      expect(model.status, isTrue);
      expect(model.data?.isActive, isTrue);
      expect(model.data?.requiresOtp, isFalse);
      expect(model.data?.user?.id, 5);
    });

    test('status 1/"1" parse as true', () {
      expect(LoginModel.fromJson({'status': 1}).status, isTrue);
      expect(LoginModel.fromJson({'status': '1'}).status, isTrue);
      expect(LoginModel.fromJson({'status': 0}).status, isFalse);
    });

    test('numeric ids arriving as strings still parse', () {
      final model = LoginModel.fromJson({
        'status': true,
        'data': {
          'user': {'id': '12', 'center_id': '3', 'city_id': 5},
        },
      });
      expect(model.data?.user?.id, 12);
      expect(model.data?.user?.centerId, 3);
      expect(model.data?.user?.cityId, 5);
    });

    test('non-map data yields null model instead of crashing', () {
      final model = LoginModel.fromJson({'status': true, 'data': []});
      expect(model.status, isTrue);
      expect(model.data, isNull);
    });
  });

  group('LoginCubit', () {
    test('success emits Success and persists token + email', () async {
      final repo = FakeLoginRepo();
      final cubit = LoginCubit(repo);

      await cubit.login(phone: '01000000000', password: '12345678', deviceToken: 'dev-token');

      expect(cubit.state, isA<LoginSuccessState>());
      expect(repo.calls, 1);
      expect(CacheTokenManger.userToken, 'tok-1');
      expect(CacheHelper.getData(key: 'email'), 'a@b.com');
    });

    test('isActive=false emits WithNoActiveState and routes to OTP', () async {
      final repo = FakeLoginRepo(isActive: false);
      final cubit = LoginCubit(repo);

      await cubit.login(phone: '01000000000', password: '12345678', deviceToken: 'dev-token');

      expect(cubit.state, isA<LoginSuccessWithNoActiveState>());
      expect(CacheHelper.getData(key: 'email'), 'a@b.com');
      expect(CacheHelper.getData(key: 'isActive'), false);
    });

    test('status false surfaces server message', () async {
      final repo = FakeLoginRepo(status: false, message: 'بيانات الدخول غير صحيحة');
      final cubit = LoginCubit(repo);

      await cubit.login(phone: '01000000000', password: 'xxx', deviceToken: 'dev-token');

      expect(cubit.state, isA<LoginErrorState>());
      expect((cubit.state as LoginErrorState).error, 'بيانات الدخول غير صحيحة');
    });

    test('network failure surfaces failure message', () async {
      final repo = FakeLoginRepo(shouldFail: true);
      final cubit = LoginCubit(repo);

      await cubit.login(phone: '01000000000', password: 'xxx', deviceToken: 'dev-token');

      expect(cubit.state, isA<LoginErrorState>());
      expect((cubit.state as LoginErrorState).error, 'offline');
    });

    test('double tap while loading issues a single request', () async {
      final repo = FakeLoginRepo();
      final cubit = LoginCubit(repo);
      await Future.wait([
        cubit.login(phone: '01000000000', password: 'p', deviceToken: 'd'),
        cubit.login(phone: '01000000000', password: 'p', deviceToken: 'd'),
      ]);
      expect(repo.calls, 1);
    });
  });

  group('LoginView', () {
    testWidgets('renders titles, CTA buttons and legal footer',
        (tester) async {
      final repo = FakeLoginRepo();
      if (getIt.isRegistered<LoginRepoImpl>()) {
        await getIt.unregister<LoginRepoImpl>();
      }
      getIt.registerSingleton<LoginRepoImpl>(repo);

      await tester.pumpWidget(_testApp());
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('تسجيل الدخول'), findsOneWidget);
      expect(find.text('إنشاء حساب جديد'), findsOneWidget);
      expect(find.text('الدخول كزائر'), findsOneWidget);
      expect(find.text('هتبيع وتشترى بكل سهولة وسرعة وأمان'),
          findsOneWidget);
    });
  });
}
