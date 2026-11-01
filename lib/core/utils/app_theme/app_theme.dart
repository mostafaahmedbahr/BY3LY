import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_colors/app_colors.dart';
import '../app_consts/storage_keys.dart';
import '../../app_services/local_services/cache_helper.dart';

/// Light and dark themes used by the app.
///
/// The selected theme is persisted with [CacheHelper], so the app starts with
/// the same theme the user chose last time.
class AppThemes {
  AppThemes._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Cairo',
    primaryColor: AppColors.mainColor,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: AppColors.mainColor,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.mainColor,
          secondary: AppColors.secondColor,
          surface: AppColors.whiteColor,
          onSurface: AppColors.blackColor,
          error: AppColors.redColor,
        ),
    scaffoldBackgroundColor: AppColors.whiteColor,
    canvasColor: AppColors.whiteColor,
    cardColor: AppColors.grey2Color,
    dividerColor: const Color(0xffE5E7EB),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      foregroundColor: AppColors.mainColor,
      shadowColor: AppColors.mainColor,
      surfaceTintColor: AppColors.mainColor,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    cardTheme: CardThemeData(
      color: AppColors.grey2Color,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    iconTheme: const IconThemeData(color: AppColors.blackColor),
    bottomAppBarTheme: const BottomAppBarThemeData(color: AppColors.whiteColor),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.darkMainColor,
      contentTextStyle: TextStyle(color: AppColors.whiteColor),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Cairo',
    primaryColor: AppColors.mainColor,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: AppColors.mainColor,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.secondColor,
          secondary: AppColors.mainColor,
          surface: AppColors.darkSurfaceColor,
          onSurface: AppColors.whiteColor,
          error: AppColors.redColor,
        ),
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    canvasColor: AppColors.darkBackgroundColor,
    cardColor: AppColors.darkSurfaceColor,
    dividerColor: Colors.white12,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurfaceColor,
      foregroundColor: AppColors.whiteColor,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurfaceColor,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    iconTheme: const IconThemeData(color: AppColors.whiteColor),
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: AppColors.darkSurfaceColor,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkSurfaceColor,
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.darkSurfaceColor,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.darkMainColor,
      contentTextStyle: TextStyle(color: AppColors.whiteColor),
    ),
  );

  /// Theme the app should start with.
  static ThemeData get initial {
    final cachedValue = CacheHelper.getData(key: StorageKeys.isDarkMode);
    final isDark = cachedValue is bool ? cachedValue : false;
    AppColors.isDark = isDark;
    return isDark ? dark : light;
  }

  /// Keeps the global [AppColors] palette in sync with the active theme.
  static void sync(ThemeData theme) {
    AppColors.isDark = theme.brightness == Brightness.dark;
  }

  /// Persists the user's theme choice.
  static Future<void> save(bool isDark) {
    return CacheHelper.saveData(key: StorageKeys.isDarkMode, value: isDark);
  }
}
