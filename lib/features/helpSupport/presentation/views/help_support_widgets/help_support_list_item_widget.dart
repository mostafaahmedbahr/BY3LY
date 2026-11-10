import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Premium contact-option row: tinted icon chip, title + subtitle,
/// trailing chevron. Hairline bordered white card (no heavy shadows).
class HelpSupportListItemWidget extends StatelessWidget {
  const HelpSupportListItemWidget({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
