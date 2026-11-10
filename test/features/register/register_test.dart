import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/utils/app_theme/app_theme.dart';
import 'package:by3ly/features/register/data/models/register_model.dart';
import 'package:by3ly/features/register/data/repos/register_repo.dart';
import 'package:by3ly/features/register/presentation/view_model/register_cubit.dart';
import 'package:by3ly/features/register/presentation/view_model/register_states.dart';
import 'package:by3ly/features/register/presentation/views/register_view.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:dartz/dartz.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, dynamic> _successJson = {
  'status': true,
  'message': 'تم إنشاء الحساب',
  'data': {
    'requires_otp': true,
    'otp': '5678',
    'email': 'resolved@mail.com',
    'next_step': 'otp',
    'expires_in': '600',
    'user': {
      'id': '55',
      'name': 'أحمد محمود',
      'email': 'ahmed@mail.com',
      'phone': '01012345678',
      'created_at': '2026-01-01',
    },
  },
};

class FakeRegisterRepo implements RegisterRepo {
  int calls = 0;
  bool shouldFail = false;
  Map<String, dynamic>? recordedPayload;

  @override
  Future<Either<Failure, RegisterModel>> register(
      {required dynamic data}) async {
    calls++;
    if (shouldFail) return Left(ServerFailure('fetch failed'));
    return Right(RegisterModel.fromJson(
      Map<String, dynamic>.from(_successJson),
    ));
  }
}

Widget _harness({required Widget child, List<BlocProvider> providers = const []}) {
  return ThemeProvider(
    initTheme: AppThemes.light,
    duration: const Duration(milliseconds: 100),
    builder: (_, theme) => ScreenUtilInit(
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
          builder: (context) => MultiBlocProvider(
            providers: [...providers],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              theme: theme,
              routes: {
                Routes.otpView: (_) =>
                    const Scaffold(body: Center(child: Text('otp-screen'))),
              },
              home: Scaffold(body: child),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
  });

  group('RegisterModel parsing', () {
    test('parses the full envelope with scalar coercion', () {
      final model = RegisterModel.fromJson(_successJson);
      expect(model.status, isTrue);
      expect(model.message, 'تم إنشاء الحساب');

      final data = model.data!;
      expect(data.requiresOtp, isTrue);
      expect(data.otp, '5678');
      expect(data.expiresIn, 600);
      expect(data.nextStep, 'otp');
      expect(data.user!.id, 55);
      expect(model.data!.resolvedEmail, 'resolved@mail.com');
      expect(model.data!.activationCode, '5678');
    });

    test('tolerates non-map data and garbage user', () {
      final model = RegisterModel.fromJson({
        'status': '1',
        'data': {'user': 7, 'requires_otp': '1'},
      });
      expect(model.status, isTrue);
      expect(model.data!.user, isNull);
      expect(model.data!.requiresOtp, isTrue);

      final model2 = RegisterModel.fromJson({'status': true, 'data': 'nope'});
      expect(model2.data, isNull);
    });

    test('resolvedEmail falls back to the nested user email', () {
      final model = RegisterModel.fromJson({
        'status': true,
        'data': {
          'user': {'email': 'nested@mail.com'},
        },
      });
      expect(model.data!.resolvedEmail, 'nested@mail.com');
    });

    test('activationCode prefers otp over legacy code', () {
      final model = RegisterModel.fromJson({
        'status': true,
        'data': {'otp': '1111', 'code': '2222'},
      });
      expect(model.data!.activationCode, '1111');

      final legacy = RegisterModel.fromJson({
        'status': true,
        'data': {'code': '2222'},
      });
      expect(legacy.data!.activationCode, '2222');
    });
  });

  group('RegisterCubit', () {
    test('initial state and password toggles', () async {
      final cubit = RegisterCubit(FakeRegisterRepo());
      expect(cubit.state, isA<RegisterInitState>());
      expect(cubit.isVisible, isTrue);
      expect(cubit.isVisible2, isTrue);

      final events = <RegisterStates>[];
      final sub = cubit.stream.listen(events.add);
      cubit.changeSuffixIcon();
      cubit.changeSuffixIcon2();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.isVisible, isFalse);
      expect(cubit.isVisible2, isFalse);
      expect(events[0], isA<ChangeSuffixIconState>());
      expect(events[1], isA<ChangeSuffixIconState2>());
      await sub.cancel();
      await cubit.close();
    });

    test('signUp success emits Loading then Success and caches the email',
        () async {
      final repo = FakeRegisterRepo();
      final cubit = RegisterCubit(repo);
      final events = <RegisterStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.signUp(
        image: null,
        phoneNumber: '01012345678',
        name: 'أحمد محمود',
        email: 'ahmed@mail.com',
        password: 'Aa1!abcd',
        age: '28',
      );
      await Future<void>.delayed(Duration.zero);

      expect(repo.calls, 1);
      expect(events.first, isA<SignUpLoading>());
      expect(events.last, isA<SignUpSuccess>());
      expect(CacheHelper.getData(key: 'email'), 'resolved@mail.com');
      expect((events.last as SignUpSuccess).registerModel.data?.otp, '5678');
      await sub.cancel();
      await cubit.close();
    });

    test('signUp failure emits Loading then Error', () async {
      final repo = FakeRegisterRepo()..shouldFail = true;
      final cubit = RegisterCubit(repo);
      final events = <RegisterStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.signUp(
        image: null,
        phoneNumber: '01012345678',
        name: 'أحمد محمود',
        email: 'ahmed@mail.com',
        password: 'Aa1!abcd',
        age: '28',
      );
      await Future<void>.delayed(Duration.zero);

      expect(events.first, isA<SignUpLoading>());
      expect((events.last as SignUpError).message, 'fetch failed');
      await sub.cancel();
      await cubit.close();
    });

    test('signUp with status false emits Error with the server message',
        () async {
      // Fake repo that returns the failure-envelope shape.
      final cubit = RegisterCubit(_StatusFalseRepo());
      final events = <RegisterStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.signUp(
        image: null,
        phoneNumber: '01012345678',
        name: 'أحمد محمود',
        email: 'ahmed@mail.com',
        password: 'Aa1!abcd',
        age: '28',
      );
      await Future<void>.delayed(Duration.zero);

      expect(events.last, isA<SignUpError>());
      expect((events.last as SignUpError).message, 'البريد مستخدم');
      await sub.cancel();
      await cubit.close();
    });

    test('clearData empties every controller and emits ClearDataSuccess',
        () async {
      final cubit = RegisterCubit(FakeRegisterRepo());
      cubit.nameCon.text = 'x';
      cubit.mobileCon.text = 'x';
      cubit.emailCon.text = 'x';
      cubit.passCon.text = 'x';
      cubit.confirmPassCon.text = 'x';
      cubit.ageCon.text = 'x';

      final events = <RegisterStates>[];
      final sub = cubit.stream.listen(events.add);
      cubit.clearData();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.nameCon.text, isEmpty);
      expect(cubit.mobileCon.text, isEmpty);
      expect(cubit.emailCon.text, isEmpty);
      expect(cubit.passCon.text, isEmpty);
      expect(cubit.confirmPassCon.text, isEmpty);
      expect(cubit.ageCon.text, isEmpty);
      expect(events.single, isA<ClearDataSuccess>());
      await sub.cancel();
      await cubit.close();
    });
  });

  group('Register widgets', () {
    Future<RegisterCubit> seededCubit() async =>
        RegisterCubit(FakeRegisterRepo());

    testWidgets('screen renders header title and CTA', (tester) async {
      tester.view.physicalSize = const Size(390, 1500);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final cubit = await seededCubit();
      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<RegisterCubit>.value(value: cubit)],
          child: const RegisterView(),
        ),
      );
      await _settle(tester);

      expect(find.text('إنشاء حساب جديد'), findsOneWidget);
      expect(find.text('التسجيل'), findsOneWidget);
      expect(find.text('اكتب رقم الهاتف هنا'), findsOneWidget);
    });

    testWidgets('password visibility icon toggles obscuring', (tester) async {
      tester.view.physicalSize = const Size(390, 1500);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final cubit = await seededCubit();
      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<RegisterCubit>.value(value: cubit)],
          child: const RegisterView(),
        ),
      );
      await _settle(tester);

      expect(cubit.isVisible, isTrue);
      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await _settle(tester);
      expect(cubit.isVisible, isFalse);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('invalid form blocks submission', (tester) async {
      tester.view.physicalSize = const Size(390, 1500);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final repo = FakeRegisterRepo();
      final cubit = RegisterCubit(repo);
      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<RegisterCubit>.value(value: cubit)],
          child: const RegisterView(),
        ),
      );
      await _settle(tester);

      await tester.tap(find.text('التسجيل'));
      await _settle(tester);

      expect(repo.calls, 0);
    });

    testWidgets('valid form registers and navigates to OTP', (tester) async {
      tester.view.physicalSize = const Size(390, 1500);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final repo = FakeRegisterRepo();
      final cubit = RegisterCubit(repo);
      cubit.mobileCon.text = '01012345678';
      cubit.nameCon.text = 'أحمد محمود';
      cubit.emailCon.text = 'ahmed@mail.com';
      cubit.ageCon.text = '28';
      cubit.passCon.text = 'Aa1!abcd';
      cubit.confirmPassCon.text = 'Aa1!abcd';

      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<RegisterCubit>.value(value: cubit)],
          child: const RegisterView(),
        ),
      );
      await _settle(tester);

      await tester.tap(find.text('التسجيل'));
      await _settle(tester);

      expect(repo.calls, 1);
      expect(find.text('otp-screen'), findsOneWidget);
      expect(CacheHelper.getData(key: 'email'), 'resolved@mail.com');
      // Fields are cleared after a successful registration.
      expect(cubit.mobileCon.text, isEmpty);
    });
  });
}

/// Repo stub: the server responds with `{status: false, message: ...}`.
class _StatusFalseRepo implements RegisterRepo {
  @override
  Future<Either<Failure, RegisterModel>> register(
      {required dynamic data}) async {
    return Right(RegisterModel.fromJson({
      'status': false,
      'message': 'البريد مستخدم',
    }));
  }
}
