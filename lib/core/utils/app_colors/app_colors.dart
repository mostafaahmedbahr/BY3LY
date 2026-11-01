import 'package:flutter/material.dart';

class AppColors {
  static const Color mainColor = Color(0xff0E8565);
  static const Color secondColor = Color(0xff279275);
  static const Color greyColor = Color(0xff7A7A7A);
  static const Color grey2Color = Color(0xffF8F8F8);
  static const Color redColor = Color(0xffC21919);
  static const Color yellowColor = Color(0xffFAB043);

  static const Color buttonColor = Color(0xff0D4B74);

  static const Color darkMainColor = Color(0xff1F2937);
  static const Color lightMainColor = Color(0x0D4B745E);

  // Dark theme surfaces
  static const Color darkBackgroundColor = Color(0xff0F172A);
  static const Color darkSurfaceColor = Color(0xff1E293B);

  static const Color greenColor = Color(0xff34C759);
  static const Color white2Color = Color(0xffF1F1F5);
  static const Color blueColor = Color(0xff60A0FF);
  static const Color blackColor = Colors.black87;
  static const Color whiteColor = Colors.white;

  /// Whether the dark theme is currently active.
  ///
  /// [AppThemes] keeps this value in sync with the active [ThemeData], so the
  /// semantic colors below always resolve to the right shade. It lets widgets
  /// use theme-aware colors without needing a [BuildContext].
  static bool isDark = false;

  /// Page / scaffold background.
  static Color get background => isDark ? darkBackgroundColor : whiteColor;

  /// Cards, inputs, dialogs and other elevated surfaces.
  static Color get surface => isDark ? darkSurfaceColor : whiteColor;

  /// Slightly tinted surface used for chips and secondary cards.
  static Color get surfaceVariant =>
      isDark ? const Color(0xff273449) : grey2Color;

  /// Primary text / icon color.
  static Color get text => isDark ? whiteColor : blackColor;

  /// Secondary text (hints, captions).
  static Color get textSecondary =>
      isDark ? const Color(0xff9CA3AF) : greyColor;

  /// Borders and dividers.
  static Color get border =>
      isDark ? const Color(0xff334155) : const Color(0xffD0D0D0);

  /// Brand color tuned for contrast on the current background.
  static Color get accent => isDark ? const Color(0xff34D399) : mainColor;

  /// Shadow color that stays visible on both themes.
  static Color get shadow =>
      isDark ? Colors.white10 : const Color(0x330E8565);
}
