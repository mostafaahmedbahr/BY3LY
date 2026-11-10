import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Empty-compare placeholder with a "back" action.
class EmptyBasket extends StatelessWidget {
  const EmptyBasket({super.key, required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 112,
              width: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceVariant,
              ),
              child: Icon(
                Icons.compare_arrows_rounded,
                size: 64,
                color: AppColors.mainColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              context.tr(LocaleKeys.pickSecondProduct),
              textAlign: TextAlign.center,
              style: AppStyles.textStyle14W500White.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 46,
              child: OutlinedButton.icon(
                onPressed: onBrowse,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text(context.tr(LocaleKeys.back)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.mainColor),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
