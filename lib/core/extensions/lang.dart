import 'package:flutter/material.dart';

extension LocaleExtensions on BuildContext {
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}