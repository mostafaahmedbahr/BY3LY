import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Premium animated toggle row (negotiable / urgent): leading icon in a
/// tinted circle, gradient outline + glow when enabled.
class SwitchRow extends StatelessWidget {
  const SwitchRow({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: value
            ? AppColors.mainColor.withValues(alpha: 0.08)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: value
              ? AppColors.mainColor.withValues(alpha: 0.5)
              : Colors.transparent,
          width: 1.4,
        ),
        boxShadow: value
            ? [
                BoxShadow(
                  color: AppColors.mainColor.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value
                  ? AppColors.mainColor.withValues(alpha: 0.14)
                  : AppColors.surface,
            ),
            child: Icon(
              icon,
              size: 19,
              color: value
                  ? AppColors.mainColor
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: value ? AppColors.mainColor : AppColors.text,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.92,
            child: Switch(
              value: value,
              activeThumbColor: AppColors.mainColor,
              activeTrackColor:
                  AppColors.mainColor.withValues(alpha: 0.35),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
