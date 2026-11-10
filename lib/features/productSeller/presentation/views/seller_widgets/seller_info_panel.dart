import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/product_seller_cubit.dart';
import '../../view_model/product_seller_states.dart';

/// Seller identity + rating summary panel, shown on the "Profile" tab.
class SellerInfoPanel extends StatelessWidget {
  const SellerInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductSellerCubit, ProductSellerStates>(
      builder: (context, state) {
        final seller =
            ProductSellerCubit.get(context).productSellerModel?.data?.seller;
        if (seller == null) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _InfoRow(
                icon: Icons.person_rounded,
                label: context.tr(LocaleKeys.sellerNameLabel),
                value: seller.name ?? '-',
              ),
              Divider(height: 20, color: AppColors.border),
              _InfoRow(
                icon: Icons.phone_rounded,
                label: context.tr(LocaleKeys.sellerPhone),
                value: seller.phone ?? '-',
              ),
              if ((seller.storeName?.trim().isNotEmpty ?? false)) ...[
                Divider(height: 20, color: AppColors.border),
                _InfoRow(
                  icon: Icons.storefront_rounded,
                  label: context.tr(LocaleKeys.viewStore),
                  value: seller.storeName!,
                ),
              ],
            ],
          ),
        );
      },
    );
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
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: AppColors.mainColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.mainColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
