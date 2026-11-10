import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/features/login/presentation/views/login_view.dart';
import 'package:by3ly/features/onBoarding/presentation/views/on_boarding_view.dart';
import 'package:by3ly/lang/ar_lang.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
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
        builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: const OnBoardingView(),
          routes: {
            Routes.loginView: (_) => const Scaffold(
                  body: Center(child: Text('login screen')),
                ),
          },
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
  });

  group('OnBoardingView', () {
    testWidgets('renders first slide and skip navigates to login',
        (tester) async {
      await tester.pumpWidget(_testApp());
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('ابدأ الآن'), findsNothing);
      expect(find.text('تخطى'), findsWidgets);

      await tester.tap(find.text('تخطى'));
      await tester.pumpAndSettle();

      expect(find.text('login screen'), findsOneWidget);
    });

    testWidgets('CTA walks through the three slides',
        (tester) async {
      await tester.pumpWidget(_testApp());
      await tester.pump(const Duration(milliseconds: 400));

      expect(
        find.text(ArLang.ar['youWillSellAndFindEverything'].toString()),
        findsOneWidget,
      );

      await tester.tap(find.text('التالي'));
      await tester.pumpAndSettle();
      expect(
        find.text(ArLang.ar['easyAndFastPurchaseProcess'].toString()),
        findsOneWidget,
      );

      await tester.tap(find.text('التالي'));
      await tester.pumpAndSettle();
      expect(
        find.text(ArLang.ar['startYourBusinessNow'].toString()),
        findsOneWidget,
      );
      expect(find.text('ابدأ الآن'), findsOneWidget);

      await tester.tap(find.text('ابدأ الآن'));
      await tester.pumpAndSettle();

      expect(find.text('login screen'), findsOneWidget);
    });
  });
}
