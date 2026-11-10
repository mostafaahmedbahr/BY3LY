import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:by3ly/features/productSeller/presentation/views/product_seller_view.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

/// Premium seller identity row: round avatar + seller name + a "view store" arrow.
class ProductSellerInfo extends StatelessWidget {
  const ProductSellerInfo({
    super.key,
    required this.sellerName,
    required this.sellerId,
    this.sellerImage = '',
  });

  final String sellerName;
  final int sellerId;
  final String sellerImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: ProductSellerView(sellerId: sellerId),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Avatar with hairline ring.
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 1.2),
              ),
              child: ClipOval(
                child: CustomNetWorkImage(
                  imageUrl: sellerImage,
                  raduis: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name + chevron.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sellerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.tr(LocaleKeys.viewStore),
                    style: TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.mainColor.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: AppColors.mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
