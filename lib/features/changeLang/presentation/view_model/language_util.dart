import 'package:flutter/material.dart';

/// Pure, framework-free helpers for language selection.
///
/// Only ['ar', 'en'] are supported; anything else falls back to 'ar'.
class LanguageUtil {
  const LanguageUtil._();

  static const List<String> supported = ['ar', 'en'];

  static const String fallbackCode = 'ar';

  /// Returns a [Locale] for [code] when it is one of the supported
  /// languages; otherwise returns the fallback locale.
  static Locale localeFromSaved(String? code) {
    if (code == null) return const Locale(fallbackCode, '');
    final trimmed = code.trim().toLowerCase();
    if (supported.contains(trimmed)) {
      return Locale(trimmed, '');
    }
    return const Locale(fallbackCode, '');
  }

  /// True when [code] is exactly one of the supported language codes.
  static bool isSupportedCode(String? code) {
    if (code == null) return false;
    return supported.contains(code.trim().toLowerCase());
  }

  /// True when the locale is RTL.
  static bool isRtl(Locale locale) => locale.languageCode == 'ar';

  /// Display name in the current UI language (not translated here; the
  /// view resolves it through locale keys so it follows the app locale).
  static String displayNameKey(String localeCode) =>
      localeCode == 'ar' ? 'arabicLang' : 'englishLang';
}
