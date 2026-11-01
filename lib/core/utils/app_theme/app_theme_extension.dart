import 'package:flutter/material.dart';

/// Theme helpers so screens can read colors from the active [ThemeData].
extension AppThemeExtension on BuildContext {
  ThemeData get appTheme => Theme.of(this);

  bool get isDarkMode => appTheme.brightness == Brightness.dark;

  /// Page / scaffold background.
  Color get appBackground => appTheme.scaffoldBackgroundColor;

  /// Cards, inputs, dialogs and elevated surfaces.
  Color get appSurface => appTheme.cardColor;

  /// Primary text / icon color.
  Color get appText => appTheme.colorScheme.onSurface;

  /// Secondary text (hints, captions).
  Color get appTextSecondary => appTheme.colorScheme.onSurfaceVariant;

  /// Borders and dividers.
  Color get appBorder => appTheme.dividerColor;
}
