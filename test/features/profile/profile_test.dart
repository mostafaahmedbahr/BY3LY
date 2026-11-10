import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/app_services/local_services/cache_token.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/deleteAccount/data/models/delete_account_model.dart' as delete_model;
import 'package:by3ly/features/profile/data/models/logout_model.dart';
import 'package:by3ly/features/profile/data/models/profile_data_model.dart';
import 'package:by3ly/features/profile/data/repos/profile_repos.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_states.dart';
import 'package:by3ly/features/profile/presentation/views/profile_view.dart';
import 'package:by3ly/features/profile/presentation/views/profile_widgets/profile_view_body.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:by3ly/core/utils/app_theme/app_theme.dart';
import 'package:dartz/dartz.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, dynamic> _profileJson = {
  'status': 'true', // stringy status — must be coerced
  'message': 'ok',
  'data': {
    'isActive': 1,
    'requires_otp': '0',
    'user': {
      'id': '7',
      'name': 'أحمد محمود',
      'email': 'ahmed@mail.com',
      'phone': '01012345678',
      'age': '28',
      'image': 'u.png',
      'token': 'tok',
      'wallet_balance': '1500',
      'wallet_currency': 'EGP',
      'center_id': '2',
      'city_id': '3',
      'cityName': 'القاهرة',
      'centerName': 'ناصر',
      'created_at': '2026-01-01',
      'subscription_package': {
        'id': '4',
        'code': 'pro',
        'name': 'PRO',
        'description': 'شهري',
        'price': '199',
        'currency': 'EGP',
        'duration_days': '30',
        'ads_limit': '50',
        'features': ['مميز 1', 'مميز 2'],
      },
    },
  },
};

class FakeProfileRepos implements ProfileRepos {
  int getProfileCalls = 0;
  int logoutCalls = 0;
  int deleteAccountCalls = 0;
  bool shouldFail = false;

  @override
  Future<Either<Failure, ProfileModel>> getProfileData() async {
    getProfileCalls++;
    if (shouldFail) return Left(ServerFailure('fetch failed'));
    return Right(ProfileModel.fromJson(
      Map<String, dynamic>.from(_profileJson),
    ));
  }

  @override
  Future<Either<Failure, LogoutModel>> logout() async {
    logoutCalls++;
    if (shouldFail) return Left(ServerFailure('logout failed'));
    return Right(LogoutModel.fromJson({
      'status': true,
      'number': 1,
      'message': 'ok',
    }));
  }

  @override
  Future<Either<Failure, delete_model.DeleteAccountModel>> deleteAccount() async {
    deleteAccountCalls++;
    if (shouldFail) return Left(ServerFailure('delete failed'));
    return Right(delete_model.DeleteAccountModel.fromJson({
      'status': true,
      'number': 2,
      'message': 'ok',
    }));
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
          builder: (context) {
            final app = MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              theme: theme,
              home: Scaffold(body: child),
            );
            return providers.isEmpty
                ? app
                : MultiBlocProvider(providers: providers, child: app);
          },
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
    const secureChannel =
        MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureChannel, (call) async => null);
  });

  setUp(() {
    CacheTokenManger.userToken = null;
    CacheHelper.saveData(key: 'isGuest', value: false);
  });

  tearDownAll(() {
    CacheHelper.saveData(key: 'isGuest', value: false);
    CacheTokenManger.userToken = null;
  });

  group('ProfileModel parsing', () {
    test('full envelope with coercion', () {
      final model = ProfileModel.fromJson(_profileJson);
      expect(model.status, isTrue);
      expect(model.data!.isActive, isTrue);
      expect(model.data!.requiresOtp, isFalse);

      final user = model.data!.user!;
      expect(user.id, 7);
      expect(user.name, 'أحمد محمود');
      expect(user.walletBalance, 1500);
      expect(user.centerId, 2);
      expect(user.cityId, 3);

      final pkg = user.subscriptionPackage!;
      expect(pkg.id, 4);
      expect(pkg.price, 199);
      expect(pkg.durationDays, 30);
      expect(pkg.adsLimit, 50);
      expect(pkg.features, ['مميز 1', 'مميز 2']);
    });

    test('tolerates non-map data / user / package payloads', () {
      final model = ProfileModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'user': 42,
          'isActive': 'true',
        },
      });
      expect(model.data, isNotNull);
      expect(model.data!.user, isNull);
      expect(model.data!.isActive, isTrue);

      final model2 = ProfileModel.fromJson({'status': 1, 'data': 'oops'});
      expect(model2.data, isNull);
    });

    test('package features of mixed types become strings', () {
      final model = ProfileModel.fromJson({
        'status': true,
        'data': {
          'user': {
            ...(_profileJson['data'] as Map)['user'] as Map,
            'subscription_package': {
              'id': 1,
              'name': 'Basic',
              'price': 100,
              'features': [1, 'raw', true],
            },
          },
        },
      });
      expect(model.data!.user!.subscriptionPackage!.features,
          ['1', 'raw', 'true']);
    });

    test('logout and delete-account envelopes coerce scalars', () {
      final logout = LogoutModel.fromJson(
          {'status': '1', 'number': '9', 'message': 'ok'});
      expect(logout.status, isTrue);
      expect(logout.number, 9);
      final delete = delete_model.DeleteAccountModel.fromJson(
          {'status': 1, 'number': '2', 'message': 'ok'});
      expect(delete.status, isTrue);
      expect(delete.number, 2);
    });
  });

  group('ProfileCubit', () {
    test('initial state is ProfileInitState', () {
      final cubit = ProfileCubit(FakeProfileRepos());
      expect(cubit.state, isA<ProfileInitState>());
      cubit.close();
    });

    test('getProfile success emits Loading → Success and fills the model',
        () async {
      final repo = FakeProfileRepos();
      final cubit = ProfileCubit(repo);
      final events = <ProfileStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getProfile();
      await Future<void>.delayed(Duration.zero);

      expect(repo.getProfileCalls, 1);
      expect(events.first, isA<GetProfileDataLoadingState>());
      expect(events.last, isA<GetProfileDataSuccessState>());
      expect(cubit.profileModel?.data?.user?.name, 'أحمد محمود');
      await sub.cancel();
      await cubit.close();
    });

    test('getProfile failure emits Loading → Error', () async {
      final repo = FakeProfileRepos()..shouldFail = true;
      final cubit = ProfileCubit(repo);
      final events = <ProfileStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getProfile();
      await Future<void>.delayed(Duration.zero);

      expect(events.first, isA<GetProfileDataLoadingState>());
      expect((events.last as GetProfileDataErrorState).error, 'fetch failed');
      expect(cubit.profileModel, isNull);
      await sub.cancel();
      await cubit.close();
    });

    test('changeNotificationValue flips the switch and emits', () async {
      final cubit = ProfileCubit(FakeProfileRepos());
      expect(cubit.switchValue, isTrue);
      final events = <ProfileStates>[];
      final sub = cubit.stream.listen(events.add);

      cubit.changeNotificationValue(false);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.switchValue, isFalse);
      expect(events.single, isA<ChangeNotificationValueState>());
      await sub.cancel();
      await cubit.close();
    });

    test('clearProfile drops cached data', () async {
      final repo = FakeProfileRepos();
      final cubit = ProfileCubit(repo);
      await cubit.getProfile();
      expect(cubit.profileModel, isNotNull);

      cubit.clearProfile();
      expect(cubit.profileModel, isNull);
      await cubit.close();
    });

    test('logout success clears token and cache and emits Success',
        () async {
      await CacheHelper.saveData(key: 'email', value: 'ahmed@mail.com');
      CacheTokenManger.userToken = 'tok';

      final repo = FakeProfileRepos();
      final cubit = ProfileCubit(repo);
      await cubit.getProfile();
      expect(cubit.profileModel, isNotNull);

      final events = <ProfileStates>[];
      final sub = cubit.stream.listen(events.add);
      await cubit.logout();
      await Future<void>.delayed(Duration.zero);

      expect(repo.logoutCalls, 1);
      expect(events.first, isA<LogoutLoadingState>());
      expect(events.last, isA<LogoutSuccessState>());
      expect(CacheTokenManger.userToken, isNull);
      expect(CacheHelper.getData(key: 'email'), isNull);
      expect(cubit.profileModel, isNull);
      await sub.cancel();
      await cubit.close();
    });

    test('logout failure keeps the session and emits Error', () async {
      CacheTokenManger.userToken = 'tok';
      final repo = FakeProfileRepos()..shouldFail = true;
      final cubit = ProfileCubit(repo);
      final events = <ProfileStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.logout();
      await Future<void>.delayed(Duration.zero);

      expect((events.last as LogoutErrorState).error, 'logout failed');
      expect(CacheTokenManger.userToken, 'tok');
      await sub.cancel();
      await cubit.close();
    });

    test('deleteAccount success clears the session like logout', () async {
      CacheTokenManger.userToken = 'tok';
      final repo = FakeProfileRepos();
      final cubit = ProfileCubit(repo);
      final events = <ProfileStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.deleteAccount();
      await Future<void>.delayed(Duration.zero);

      expect(repo.deleteAccountCalls, 1);
      expect(events.first, isA<DeleteAccountLoadingState>());
      expect(events.last, isA<DeleteAccountSuccessState>());
      expect(CacheTokenManger.userToken, isNull);
      await sub.cancel();
      await cubit.close();
    });
  });

  group('Profile widgets', () {
    Future<Widget> bodyWithProfile() async {
      final cubit = ProfileCubit(FakeProfileRepos());
      await cubit.getProfile();
      return _harness(
        providers: [BlocProvider<ProfileCubit>.value(value: cubit)],
        child: const ProfileViewBody(),
      );
    }

    testWidgets('header shows the user name and phone', (tester) async {
      await tester.pumpWidget(await bodyWithProfile());
      await _settle(tester);

      expect(find.text('أحمد محمود'), findsWidgets);
      expect(find.text('01012345678'), findsOneWidget);
    });

    testWidgets('quick actions row renders the four shortcuts',
        (tester) async {
      await tester.pumpWidget(await bodyWithProfile());
      await _settle(tester);

      expect(find.text('الدفع والرصيد'), findsOneWidget);
      expect(find.text('المفضلة'), findsOneWidget);
      expect(find.text('إحصائيات'), findsOneWidget);
      expect(find.text('المقارنة'), findsOneWidget);
    });

    testWidgets('logout CTA opens the confirm dialog and cancel closes it',
        (tester) async {
      // Taller surface so the Sign-out CTA fits on screen (the body is
      // a long settings ListView and tapping off-screen would be a miss).
      tester.view.physicalSize = const Size(390, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(await bodyWithProfile());
      await _settle(tester);

      await tester.tap(find.text('تسجيل الخروج').first);
      await _settle(tester);

      expect(find.text('تأكيد تسجيل الخروج'), findsOneWidget);

      await tester.tap(find.text('إلغاء'));
      await _settle(tester);

      expect(find.text('تأكيد تسجيل الخروج'), findsNothing);
    });

    testWidgets('guest mode shows the guest placeholder', (tester) async {
      await CacheHelper.saveData(key: 'isGuest', value: true);
      await tester.pumpWidget(_harness(child: const ProfileView()));
      await _settle(tester);

      expect(find.text('أنت تتصفح كزائر'), findsOneWidget);
      expect(find.text('أحمد محمود'), findsNothing);

      await CacheHelper.saveData(key: 'isGuest', value: false);
    });
  });
}
