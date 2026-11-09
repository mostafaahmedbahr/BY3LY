import 'package:by3ly/features/addBalance/presentation/view_model/add_balance_config.dart';
import 'package:by3ly/features/addBalance/presentation/view_model/add_balance_cubit.dart';
import 'package:by3ly/features/addBalance/presentation/view_model/add_balance_states.dart';
import 'package:by3ly/features/addBalance/presentation/views/add_balance_widgets/add_balance_view_body.dart';
import 'package:by3ly/features/confirmPayment/presentation/view_model/confirm_payment_cubit.dart';
import 'package:by3ly/features/confirmPayment/presentation/views/confirm_payment_view.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

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
          BlocProvider(create: (_) => ConfirmPaymentCubit()),
        ],
        // Wire localization exactly like main.dart does.
        child: Builder(
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: Scaffold(
              body: child ?? const AddBalanceViewBody(),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Provide an in-memory plugins for the test binding (no device).
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  group('AddBalanceConfig', () {
    test('support numbers are non-empty, unique and E.164-like', () {
      expect(AddBalanceConfig.supportPhoneNumbers, isNotEmpty);
      expect(AddBalanceConfig.supportPhoneNumbers.toSet().length,
          AddBalanceConfig.supportPhoneNumbers.length);
      for (final number in AddBalanceConfig.supportPhoneNumbers) {
        expect(number, startsWith('+'));
      }
    });

    test('bank account number is digits only', () {
      expect(AddBalanceConfig.accountNumber, matches(RegExp(r'^[0-9]+$')));
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

  testWidgets('renders both payment-method tiles', (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    expect(find.text('فودافون كاش'), findsOneWidget);
    expect(find.text('انستاباي'), findsOneWidget);
    expect(find.text('ايداع لحظي'), findsNWidgets(2));
  });

  testWidgets('vodafone tile opens a dismissible dialog with all numbers',
      (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('فودافون كاش'));
    await tester.pumpAndSettle();

    // Dialog lists every support number with copy + call actions.
    for (final number in AddBalanceConfig.supportPhoneNumbers) {
      expect(find.text(number), findsOneWidget);
    }
    expect(find.byIcon(Icons.copy_rounded), findsWidgets);

    // Dismiss via the close (X) button.
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text(AddBalanceConfig.supportPhoneNumbers.first),
        findsNothing);
  });

  testWidgets('instapay tile opens the bottom sheet with the bank account',
      (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('انستاباي'));
    await tester.pumpAndSettle();

    expect(find.text(AddBalanceConfig.accountNumber), findsOneWidget);
    expect(find.text('رقم الحساب'), findsOneWidget);
  });

  testWidgets('confirm button navigates to ConfirmPaymentView',
      (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('تاكيد الدفع'));
    await tester.pumpAndSettle();

    expect(find.byType(ConfirmPaymentView), findsOneWidget);
  });
}
