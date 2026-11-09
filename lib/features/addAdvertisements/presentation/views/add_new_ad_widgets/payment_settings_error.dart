import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

/// ad-publishing-settings failed to load → the fee cannot be shown.
/// Offers a retry button instead of blocking the whole sheet.
class PaymentSettingsError extends StatelessWidget {
  const PaymentSettingsError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 38,
            color: AppColors.redColor,
          ),
          const SizedBox(height: 8),
          Text(
            'تعذر تحميل إعدادات النشر. حاول مرة أخرى.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          CustomButton(
            btnText: const Text(
              'إعادة المحاولة',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
