import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/features/changeLang/presentation/views/change_lang_view.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:by3ly/features/changeLang/presentation/view_model/change_lang_cubit.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
    await EasyLocalization.ensureInitialized();
  });

  Widget languageSheetHarness({required Locale start}) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => EasyLocalization(
        startLocale: start,
        supportedLocales: const [Locale('ar', ''), Locale('en', '')],
        path: 'assets/lang',
        assetLoader: const CodegenLoader(),
        fallbackLocale: const Locale('en', ''),
        useOnlyLangCode: true,
        saveLocale: true,
        child: Builder(
          builder: (context) => MaterialApp(
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: BlocProvider(
              create: (_) => LanguageCubit(),
              child: const Scaffold(body: ChangeLangSheet()),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('both options visible with Arabic as default',
      (tester) async {
    CacheHelper.saveData(key: 'language', value: 'ar');
    await tester.pumpWidget(languageSheetHarness(start: const Locale('ar', '')));
    await tester.pumpAndSettle();

    // Both options visible (labels follow the active locale)
    expect(find.textContaining('العربية'), findsOneWidget);
    expect(find.textContaining('English'), findsOneWidget);

    // Arabic option shows the check mark (it's preselected)
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('English start locale shows English as selected',
      (tester) async {
    CacheHelper.saveData(key: 'language', value: 'en');
    await tester.pumpWidget(languageSheetHarness(start: const Locale('en', '')));
    await tester.pumpAndSettle();

    expect(find.textContaining('English'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('tapping the currently selected language pops the sheet',
      (tester) async {
    CacheHelper.saveData(key: 'language', value: 'ar');
    await tester.pumpWidget(languageSheetHarness(start: const Locale('ar', '')));
    await tester.pumpAndSettle();

    // Tap the Arabic option (it's current) — should pop the sheet,
    // not call refreshAllData.
    await tester.tap(find.textContaining('العربية'));
    await tester.pumpAndSettle();

    // After pop, the sheet is gone.
    expect(find.textContaining('العربية'), findsNothing);
  });
}
