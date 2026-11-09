import 'package:by3ly/features/changeLang/presentation/view_model/language_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('localeFromSaved', () {
    test('null maps to Arabic fallback', () {
      final locale = LanguageUtil.localeFromSaved(null);
      expect(locale.languageCode, 'ar');
    });

    test('empty / whitespace maps to fallback', () {
      expect(LanguageUtil.localeFromSaved('').languageCode, 'ar');
      expect(LanguageUtil.localeFromSaved('   ').languageCode, 'ar');
    });

    test('valid codes round-trip (trim + case-insensitive)', () {
      expect(LanguageUtil.localeFromSaved('ar').languageCode, 'ar');
      expect(LanguageUtil.localeFromSaved('ar ').languageCode, 'ar');
      expect(LanguageUtil.localeFromSaved(' AR ').languageCode, 'ar');
      expect(LanguageUtil.localeFromSaved('en').languageCode, 'en');
      expect(LanguageUtil.localeFromSaved('EN').languageCode, 'en');
    });

    test('unknown codes fall back to Arabic', () {
      expect(LanguageUtil.localeFromSaved('fr').languageCode, 'ar');
      expect(LanguageUtil.localeFromSaved('spanish').languageCode, 'ar');
      expect(LanguageUtil.localeFromSaved('123').languageCode, 'ar');
    });

    test('locale has empty country code as expected by the app', () {
      final locale = LanguageUtil.localeFromSaved('en');
      expect(locale.countryCode, '');
    });
  });

  group('isSupportedCode', () {
    test('true for ar/en with trim/case normalization', () {
      expect(LanguageUtil.isSupportedCode('ar'), isTrue);
      expect(LanguageUtil.isSupportedCode('en'), isTrue);
      expect(LanguageUtil.isSupportedCode('AR'), isTrue);
      expect(LanguageUtil.isSupportedCode(' en '), isTrue);
    });

    test('false for null, empty, unknown', () {
      expect(LanguageUtil.isSupportedCode(null), isFalse);
      expect(LanguageUtil.isSupportedCode(''), isFalse);
      expect(LanguageUtil.isSupportedCode('fr'), isFalse);
      expect(LanguageUtil.isSupportedCode('arabic'), isFalse);
    });
  });

  group('isRtl', () {
    test('ar is RTL, en is LTR', () {
      expect(LanguageUtil.isRtl(const Locale('ar', '')), isTrue);
      expect(LanguageUtil.isRtl(const Locale('en', '')), isFalse);
    });
  });

  group('displayNameKey', () {
    test('returns the locale_appending key for each supported language', () {
      expect(LanguageUtil.displayNameKey('ar'), 'arabicLang');
      expect(LanguageUtil.displayNameKey('en'), 'englishLang');
    });
  });
}
