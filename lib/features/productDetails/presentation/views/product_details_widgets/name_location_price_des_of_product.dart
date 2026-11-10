import 'package:by3ly/core/shared_widgets/product_badges.dart';
import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/productDetails/data/models/product_details_model.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';

class NameAndLocationAndPriceAndDesOfProduct extends StatelessWidget {
  const NameAndLocationAndPriceAndDesOfProduct({super.key, this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    final name = product?.name ?? '';
    final price = product?.price ?? '';
    final currency = product?.currency?.trim() ?? '';
    final desc = product?.desc?.trim() ?? '';
    final location = product?.location?.toString().trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          name,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 19,
            height: 1.3,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
            letterSpacing: -0.1,
          ),
        ),
        // Urgent / featured badges + total views.
        if (product?.isUrgent == true ||
            isFeatured(product?.status) ||
            (product?.views ?? 0) > 0) ...[
          const CustomSizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (product?.isUrgent == true)
                const ProductBadges(isUrgent: true, elevated: false),
              if (isFeatured(product?.status))
                const ProductBadges(featured: true, elevated: false),
              if ((product?.views ?? 0) > 0)
                ProductViewsLabel(views: product!.views, fontSize: 12),
            ],
          ),
        ],
        const CustomSizedBox(height: 12),
        // Location chip — green filled pill with map-pin SVG.
        if (location.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.mainColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.mainColor.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppImages.location,
                  width: 14,
                  height: 14,
                ),
                const CustomSizedBox(width: 6),
                Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainColor,
                  ),
                ),
              ],
            ),
          ),
          const CustomSizedBox(height: 14),
        ],
        // Price row — big bold green + currency subdued.
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price,
              style: const TextStyle(
                fontSize: 26,
                height: 1.0,
                fontWeight: FontWeight.w900,
                color: AppColors.mainColor,
                letterSpacing: -0.3,
              ),
            ),
            if (currency.isNotEmpty) ...[
              const CustomSizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  currency,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (desc.isNotEmpty) ...[
          const CustomSizedBox(height: 14),
          Divider(height: 1, color: AppColors.border),
          const CustomSizedBox(height: 12),
          Text(
            context.tr(LocaleKeys.desAboutProduct),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
          const CustomSizedBox(height: 6),
          ReadMoreText(
            desc,
            trimLines: 2,
            colorClickableText: AppColors.mainColor,
            trimMode: TrimMode.Line,
            trimCollapsedText: context.tr(LocaleKeys.seeMore),
            trimExpandedText: context.tr(LocaleKeys.seeLess),
            style: TextStyle(
              fontSize: 13.5,
              height: 1.6,
              color: AppColors.text,
            ),
            moreStyle: const TextStyle(
              fontSize: 13.5,
              height: 1.6,
              fontWeight: FontWeight.w700,
              color: AppColors.mainColor,
            ),
          ),
        ],
      ],
    );
  }
}
