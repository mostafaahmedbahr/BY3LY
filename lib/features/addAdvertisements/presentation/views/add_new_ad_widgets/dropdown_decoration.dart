import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Shared decoration for every dropdown in the ad form.
InputDecoration dropdownDecoration(String label, {Widget? prefix}) {
  return InputDecoration(
    fillColor: AppColors.surfaceVariant,
    filled: true,
    prefixIcon: prefix,
    labelText: label,
    labelStyle: TextStyle(color: AppColors.accent),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.mainColor),
    ),
  );
}
