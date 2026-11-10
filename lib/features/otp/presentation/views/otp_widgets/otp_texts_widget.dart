import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Branded activation header: gold key icon chip + headline + the email
/// chip the code was sent to (gold pill with icon).
class OtpTexts extends StatelessWidget {
  const OtpTexts({super.key, required this.email});

  final String email;

  String get _resolvedEmail =>
      email.trim().isNotEmpty
          ? email
          : (CacheHelper.getData(key: 'email')?.toString() ?? '');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: AppColors.yellowColor.withValues(alpha: 0.16),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.yellowColor.withValues(alpha: 0.65),
                  width: 1.4,
                ),
              ),
              child: const Icon(
                Icons.key_rounded,
                size: 22,
                color: AppColors.yellowColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              context.tr(LocaleKeys.confirmEmail),
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
                height: 1.2,
              ).copyWith(color: AppColors.text),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          context.tr(LocaleKeys.checkEmail),
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        // Email chip — gold-bordered pill.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.mainColor.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.mainColor.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.mark_email_unread_rounded,
                size: 17,
                color: AppColors.mainColor,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _resolvedEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
