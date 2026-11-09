import 'package:flutter/material.dart';

import 'package:by3ly/core/utils/app_colors/app_colors.dart';

/// Single-select premium choice tag used by the filter sheet
/// (type chips, price presets, shipping and condition options).
class FilterOptionChip extends StatelessWidget {
  const FilterOptionChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final content = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected
                    ? Colors.white
                    : AppColors.mainColor,
              ),
              const SizedBox(width: 6),
              Text(label),
            ],
          );
    return ChoiceChip(
      label: content,
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.mainColor,
      backgroundColor: AppColors.surfaceVariant,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.text,
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: selected ? AppColors.mainColor : AppColors.border,
          width: selected ? 1.2 : 1,
        ),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }
}
