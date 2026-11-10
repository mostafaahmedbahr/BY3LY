import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Safety tips for cash-on-delivery / meet-the-seller flows, translated at
/// build time so a language switch repaints instantly.
class TipsForYourSafety extends StatelessWidget {
  const TipsForYourSafety({super.key});

  static List<String> _tips(BuildContext context) => [
        context.tr(LocaleKeys.inspectProductThoroughlyBeforeBuying),
        context.tr(LocaleKeys.takeSomeoneWithYou),
        context.tr(LocaleKeys.dontPayUntilEnsuringSafety),
        context.tr(LocaleKeys.meetSellerInPublicPlace),
      ];

  @override
  Widget build(BuildContext context) {
    final tips = _tips(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.yellowColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.yellowColor.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 16,
                color: Color(0xff8A6D1C),
              ),
              const SizedBox(width: 6),
              Text(
                context.tr(LocaleKeys.tipsForYourSafety),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff8A6D1C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final tip in tips)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 14,
                      color: Color(0xff8A6D1C),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
