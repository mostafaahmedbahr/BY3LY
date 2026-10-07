import 'package:flutter/material.dart';

import '../../../../../core/shared_widgets/custom_button.dart';
import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../../data/models/packages_model.dart';
import 'payment_method_sheet.dart';

/// Single subscription package card.
class PackageCard extends StatelessWidget {
  const PackageCard({super.key, required this.package});

  final Packages package;

  @override
  Widget build(BuildContext context) {
    final isFree = package.isFree == true;
    final priceText =
        isFree ? 'مجاناً' : _formatPrice(package.price);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    package.name ?? '',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1F2937),
                    ),
                  ),
                ),
                if (package.durationLabel.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          AppColors.mainColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      package.durationLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),
              ],
            ),
            if ((package.description?.trim().isNotEmpty ?? false)) ...[
              const SizedBox(height: 6),
              Text(
                package.description!,
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.6,
                  color: Color(0xff9AA0A6),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  priceText,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.mainColor,
                  ),
                ),
                if (!isFree &&
                    (package.currency?.trim().isNotEmpty ??
                        false)) ...[
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      package.currency!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff9AA0A6),
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (package.adsLimit != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xffF1F3F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${package.adsLimit} إعلان',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),
              ],
            ),
            if ((package.features?.isNotEmpty ?? false)) ...[
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF0F0F0)),
              const SizedBox(height: 12),
              ...package.features!.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: Color(0xff1F2937),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            // Current subscription info (only when subscribed).
            if (package.isSubscriped == true) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.calendar_month_outlined,
                      label: 'تاريخ الانتهاء',
                      value: _formatDate(package.endsAt),
                    ),
                    const SizedBox(height: 6),
                    _InfoRow(
                      icon: Icons.campaign_outlined,
                      label: 'الإعلانات المتبقية',
                      value: package.remainingAds != null
                          ? '${package.remainingAds} إعلان'
                          : '...',
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            CustomButton(
              btnText: Text(
                package.isSubscriped == true
                    ? "تجديد الاشتراك"
                    : "اشترك الآن",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onPressed: () =>
                  showPaymentMethodSheet(context, package),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double? value) {
    if (value == null) return '...';
    // Whole numbers without trailing ".0".
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  /// Shows only the date part of "ends_at" (2026-12-31 ...).
  String _formatDate(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return '...';
    if (v.length > 10) return v.substring(0, 10);
    return v;
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.mainColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xff9AA0A6),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xff1F2937),
          ),
        ),
      ],
    );
  }
}
