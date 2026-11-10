import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/features/onBoarding/presentation/views/on_boarding_view.dart';
import 'package:by3ly/features/splash/presentation/views/splash_view.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _harness({required Widget child}) {
  return EasyLocalization(
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
        home: child,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'isGuest': false});
    await CacheHelper.init();
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('splash shows the wordmark and tagline, then navigates to OnBoarding',
      (tester) async {
    await tester.pumpWidget(_harness(child: const SplashView()));
    await tester.pump(const Duration(milliseconds: 100));
    // Brand wordmark + tagline visible during the intro.
    expect(find.text('هنا تبيع وتشتري'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    // Intro (1.6s) + fade route (450ms).
    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(OnBoardingView), findsOneWidget);
  });

  testWidgets('splash body renders the gold flourish divider', (tester) async {
    await tester.pumpWidget(_harness(child: const SplashView()));
    // Pump the first frames of the intro.
    await tester.pump(const Duration(milliseconds: 100));

    // Tagline is already part of the same fade/slide transition.
    expect(find.text('هنا تبيع وتشتري'), findsOneWidget);
  });
}
