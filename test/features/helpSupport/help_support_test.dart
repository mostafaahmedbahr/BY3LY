import 'package:by3ly/features/helpSupport/presentation/view-model/help_support_config.dart';
import 'package:by3ly/features/helpSupport/presentation/view-model/help_support_cubit.dart';
import 'package:by3ly/features/helpSupport/presentation/view-model/help_support_states.dart';
import 'package:by3ly/features/helpSupport/presentation/views/help_support_view.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

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
        builder: (context) => BlocProvider(
          create: (_) => HelpSupportCubit(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: const HelpSupportView(),
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

  group('HelpSupportConfig', () {
    test('contact channels are non-empty and well formed', () {
      expect(HelpSupportConfig.email, contains('@'));
      expect(HelpSupportConfig.phone.trim(), isNotEmpty);
      expect(HelpSupportConfig.phoneE164, startsWith('+'));
      expect(HelpSupportConfig.phoneE164.replaceAll('+', ''),
          matches(RegExp(r'^[0-9]+$')));
    });

    test('mailto URI carries scheme, path and encoded subject', () {
      final uri = HelpSupportConfig.buildMailtoUri(subject: 'الدعم الفني');
      expect(uri.scheme, 'mailto');
      expect(uri.path, HelpSupportConfig.email);
      expect(uri.queryParameters['subject'], 'الدعم الفني');
    });

    test('mailto without subject omits the query entirely', () {
      expect(HelpSupportConfig.buildMailtoUri().query, isEmpty);
    });

    test('tel URI uses the E.164 support line', () {
      final uri = HelpSupportConfig.buildTelUri();
      expect(uri.scheme, 'tel');
      expect(uri.path, HelpSupportConfig.phoneE164);
    });
  });

  group('HelpSupportCubit', () {
    test('starts in HelpSupportInitState', () {
      final cubit = HelpSupportCubit();
      expect(cubit.state, isA<HelpSupportInitState>());
      cubit.close();
    });

    test('launch methods return false instead of throwing on failure',
        () async {
      final cubit = HelpSupportCubit();
      // No mail client / dialer plugin in the test binding — the cubit
      // must degrade gracefully instead of crashing.
      expect(await cubit.sendEmail(subject: 'test'), isFalse);
      expect(await cubit.makePhoneCall(), isFalse);
      cubit.close();
    });
  });

  group('HelpSupportView', () {
    testWidgets('renders contact tiles and the FAQ section', (tester) async {
      await tester.pumpWidget(_testApp());
      await tester.pumpAndSettle();

      expect(find.text('المحادثة'), findsOneWidget);
      expect(find.text('الايميل'), findsOneWidget);
      expect(find.text('اتصل بنا'), findsOneWidget);
      expect(find.text(HelpSupportConfig.email), findsOneWidget);
      expect(find.text(HelpSupportConfig.phone), findsOneWidget);
      expect(find.text('الاسئلة الشائعة'), findsOneWidget);
    });

    testWidgets('FAQ answer is collapsed by default and expands on tap',
        (tester) async {
      await tester.pumpWidget(_testApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('بيعلي غير مسؤول'), findsNothing);

      await tester.tap(find.text('كيف تتم عملية الشراء؟!'));
      await tester.pumpAndSettle();

      expect(find.textContaining('بيعلي غير مسؤول'), findsOneWidget);
    });
  });
}
