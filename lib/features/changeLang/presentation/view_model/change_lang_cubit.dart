import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en', '')); // Initialize with a default locale

  void changeLanguage(BuildContext context, Locale locale) {
    EasyLocalization.of(context)?.setLocale(locale);
    emit(locale);
  }
}