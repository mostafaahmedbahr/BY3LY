import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Loose int coercion for the adToEdit payload (id may arrive as
/// int / num / String / double).
int? asIntOrNull(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

/// Maps the validation keys emitted by AddNewAdCubit.validate() to localized
/// messages shown in the snackbar.
String addNewAdValidationMessage(BuildContext context, String key) {
  switch (key) {
    case 'imagesRequired':
      return context.tr(LocaleKeys.imagesRequired);
    case 'nameRequired':
      return context.tr(LocaleKeys.nameRequired);
    case 'descRequired':
      return context.tr(LocaleKeys.descRequired);
    case 'priceRequired':
      return context.tr(LocaleKeys.priceRequired);
    case 'categoryRequired':
      return context.tr(LocaleKeys.categoryRequired);
    case 'subCategoryRequired':
      return context.tr(LocaleKeys.subCategoryRequired);
    case 'cityRequired':
      return context.tr(LocaleKeys.cityRequired);
    case 'centerRequired':
      return context.tr(LocaleKeys.centerRequired);
    default:
      return key;
  }
}
