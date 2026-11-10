import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Red-tinted hero at the top of the delete-account screen — the danger
/// zone is announced before the user reads the details.
class DeleteWarningHero extends StatelessWidget {
  const DeleteWarningHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.redColor.withValues(alpha: 0.10),
            AppColors.redColor.withValues(alpha: 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.redColor.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.redColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.redColor.withValues(alpha: 0.30),
              ),
            ),
            child: const Icon(
              Icons.delete_forever_rounded,
              color: AppColors.redColor,
              size: 36,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.tr(LocaleKeys.notice).toUpperCase(),
            style: TextStyle(
              color: AppColors.redColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr(LocaleKeys.accountDeletionWarning),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.55,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
