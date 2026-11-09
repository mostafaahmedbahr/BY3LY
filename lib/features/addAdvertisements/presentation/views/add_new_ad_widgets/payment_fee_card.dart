import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Premium fee + wallet-balance summary for the payment sheet.
class PaymentFeeCard extends StatelessWidget {
  const PaymentFeeCard({
    super.key,
    required this.feeLabel,
    required this.balanceLabel,
  });

  final String feeLabel;
  final String balanceLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x142E8B6F),
            Color(0x0FFFFFFF),
          ],
        ),
        border: Border.all(
          color: AppColors.mainColor.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          _FeeRow(
            icon: Icons.local_offer_outlined,
            label: 'رسوم النشر',
            value: feeLabel,
            valueColor: AppColors.mainColor,
            boldValue: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 1,
              color: AppColors.mainColor.withValues(alpha: 0.15),
            ),
          ),
          _FeeRow(
            icon: Icons.account_balance_wallet_outlined,
            label: 'رصيد المحفظة',
            value: balanceLabel,
            valueColor: AppColors.text,
            boldValue: false,
          ),
        ],
      ),
    );
  }
}

/// One label/value row with a leading tinted icon circle.
class _FeeRow extends StatelessWidget {
  const _FeeRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.boldValue,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final bool boldValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.mainColor.withValues(alpha: 0.12),
          ),
          child: Icon(icon, color: AppColors.mainColor, size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: boldValue ? 16 : 14,
            fontWeight: boldValue ? FontWeight.w800 : FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
