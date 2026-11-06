import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_services/local_services/cache_helper.dart';
import '../../../../core/utils/app_consts/storage_keys.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(_getSavedLocale());

  static Locale _getSavedLocale() {
    final savedLanguage = CacheHelper.getData(key: StorageKeys.language);
    if (savedLanguage is String && savedLanguage.isNotEmpty) {
      return Locale(savedLanguage, '');
    }
    return const Locale('ar', '');
  }

  void changeLanguage(BuildContext context, Locale locale) {
    // Save first so the next request (Dio interceptor) sends the new language.
    CacheHelper.saveData(key: StorageKeys.language, value: locale.languageCode);
    EasyLocalization.of(context)?.setLocale(locale);
    emit(locale);
  }
}