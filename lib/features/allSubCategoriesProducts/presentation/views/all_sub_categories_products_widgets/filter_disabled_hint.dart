import 'package:flutter/material.dart';

import 'package:by3ly/core/utils/app_colors/app_colors.dart';

/// Small tinted hint used when a section is not applicable yet
/// (e.g. sub-category before picking a category).
class FilterDisabledHint extends StatelessWidget {
  const FilterDisabledHint({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
      ),
    );
  }
}
