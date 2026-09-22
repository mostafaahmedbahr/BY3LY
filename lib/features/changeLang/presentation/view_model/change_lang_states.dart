import 'package:flutter/material.dart';

abstract class LocalizationState {}

class LocalizationInitialState extends LocalizationState {}

class LocalizationChangedState extends LocalizationState {
  final Locale locale;

  LocalizationChangedState(this.locale);
}