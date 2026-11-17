import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/PaymentBalance/data/models/wallet_history_model.dart';
import 'package:by3ly/features/PaymentBalance/data/repos/wallet_repos_imple.dart';
import 'package:by3ly/features/PaymentBalance/presentation/views/payment_and_balance_view.dart';
import 'package:by3ly/features/addBalance/presentation/view_model/add_balance_config.dart';
import 'package:by3ly/features/addBalance/presentation/view_model/add_balance_cubit.dart';
import 'package:by3ly/features/addBalance/presentation/view_model/add_balance_states.dart';
import 'package:by3ly/features/addBalance/presentation/views/add_balance_widgets/add_balance_view_body.dart';
import 'package:by3ly/features/packages/data/models/packages_model.dart';
import 'package:by3ly/features/profile/data/models/profile_data_model.dart';
import 'package:by3ly/features/profile/data/repos/profile_repos_imple.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/features/packages/data/repos/packages_repos_imple.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeWalletRepo extends WalletRepoImpl {
  _FakeWalletRepo() : super(null);

  @override
  Future<Either<Failure, WalletHistoryModel>> getHistory() async =>
      right(WalletHistoryModel());
}

class _FakePackagesRepo extends PackagesRepoImpl {
  _FakePackagesRepo() : super(null);

  @override
  Future<Either<Failure, PackagesModel>> getPackages() async =>
      right(PackagesModel());
}

class _FakeProfileRepo extends ProfileRepoImpl {
  _FakeProfileRepo() : super(null);

  @override
  Future<Either<Failure, ProfileModel>> getProfileData() async =>
      right(ProfileModel());
}

Widget _testApp({Widget? child}) {
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AddBalanceCubit()),
          BlocProvider(create: (_) => ProfileCubit(_FakeProfileRepo())),
        ],
        child: Builder(
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: Scaffold(body: child ?? const AddBalanceViewBody()),
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() async {
    if (getIt.isRegistered<WalletRepoImpl>()) {
      await getIt.unregister<WalletRepoImpl>();
    }
    if (getIt.isRegistered<PackagesRepoImpl>()) {
      await getIt.unregister<PackagesRepoImpl>();
    }
    getIt.registerSingleton<WalletRepoImpl>(_FakeWalletRepo());
    getIt.registerSingleton<PackagesRepoImpl>(_FakePackagesRepo());
  });

  tearDown(() async {
    if (getIt.isRegistered<WalletRepoImpl>()) {
      await getIt.unregister<WalletRepoImpl>();
    }
    if (getIt.isRegistered<PackagesRepoImpl>()) {
      await getIt.unregister<PackagesRepoImpl>();
    }
  });

  group('AddBalanceConfig', () {
    test('support numbers are real and non-empty', () {
      expect(AddBalanceConfig.supportPhoneNumbers, isNotEmpty);
      expect(
        AddBalanceConfig.supportPhoneNumbers.toSet().length,
        AddBalanceConfig.supportPhoneNumbers.length,
      );
      for (final number in AddBalanceConfig.supportPhoneNumbers) {
        expect(number, startsWith('+'));
      }
    });

    test('no hardcoded transfer account is shipped by default', () {
      final account = AddBalanceConfig.accountNumber;
      if (account.isEmpty) return;
      expect(account, matches(RegExp(r'^[0-9]+$')));
    });
  });

  group('AddBalanceCubit', () {
    test('starts with AddBalanceInitState and proxies the config', () {
      final cubit = AddBalanceCubit();
      expect(cubit.state, isA<AddBalanceInitState>());
      expect(cubit.phoneNumbers, AddBalanceConfig.supportPhoneNumbers);
      cubit.close();
    });
  });

  testWidgets('legacy screen shows no placeholder transfer numbers', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    expect(find.text('+1234567890'), findsNothing);
    expect(find.text('+0987654321'), findsNothing);
    expect(find.text('+1122334455'), findsNothing);
    expect(find.text('123456789023'), findsNothing);
    expect(find.text('فتح شحن الرصيد'), findsOneWidget);
  });

  testWidgets('confirm button opens the server-verified wallet top-up', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('فتح شحن الرصيد'));
    // The wallet screen has shimmer/animation loops — pump manually.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(PaymentAndBalanceView), findsOneWidget);
  });
}
