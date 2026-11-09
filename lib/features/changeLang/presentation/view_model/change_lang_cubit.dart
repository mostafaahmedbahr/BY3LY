import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_services/local_services/cache_helper.dart';
import '../../../../core/utils/app_consts/storage_keys.dart';
import 'language_util.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(_getSavedLocale());

  static Locale _getSavedLocale() {
    final savedLanguage = CacheHelper.getData(key: StorageKeys.language);
    if (savedLanguage is String) {
      return LanguageUtil.localeFromSaved(savedLanguage);
    }
    return const Locale('ar', '');
  }

  /// Persists the choice first so the next request (Dio interceptor)
  /// sends the new language, then updates the active locale.
  void changeLanguage(BuildContext context, Locale locale) {
    CacheHelper.saveData(
      key: StorageKeys.language,
      value: locale.languageCode,
    );
    EasyLocalization.of(context)?.setLocale(locale);
    emit(locale);
  }
}
