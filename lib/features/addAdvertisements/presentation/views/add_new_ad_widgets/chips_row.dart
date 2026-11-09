import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

/// One option of a [ChipsRow].
class ChipOption {
  final String value;
  final String label;

  const ChipOption({required this.value, required this.label});
}

/// Single-select premium chip row: gradient + check when selected,
/// quiet tinted pill when not. Used for shipping & condition.
class ChipsRow extends StatelessWidget {
  const ChipsRow({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<ChipOption> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((o) {
        final isSelected = selected == o.value;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onSelected(o.value),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [
                          AppColors.mainColor,
                          AppColors.secondColor,
                        ],
                      )
                    : null,
                color: isSelected ? null : AppColors.surfaceVariant,
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : AppColors.border.withValues(alpha: 0.7),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.mainColor
                              .withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    o.label,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.text,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
