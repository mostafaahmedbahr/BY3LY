import 'package:by3ly/core/shared_widgets/fav_heart_button.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/search/data/models/all_products_search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/extensions/navigate.dart';
import '../../../../../core/shared_widgets/custom_cached_network_image.dart';
import '../../../../../core/shared_widgets/custom_sized_box.dart';
import '../../../../../core/utils/app_styles/app_styles.dart';

class SearchItemWidget extends StatelessWidget {
  const SearchItemWidget({super.key, required this.product});
  final Products product;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.pushNamed(Routes.productDetailsView, arguments: {
          "type": "home",
          "productId": product.id ?? 0,
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetWorkImage(
              imageUrl: product.image ?? '',
              raduis: 10,
              fit: BoxFit.cover,
              width: 110,
              height: 124,
            ),
            const CustomSizedBox(width: 12,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(product.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1F2937),
                          ),
                        ),
                      ),
                      FavHeartButton(
                        productId: product.id,
                        initialIsFavourite: product.isFavourite == true,
                        withBackground: false,
                        iconSize: 22,
                      ),
                    ],
                  ),
                  const CustomSizedBox(height: 4,),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.location,
                        width: 14,
                        height: 14,
                      ),
                      const CustomSizedBox(width: 4,),
                      Expanded(
                        child: Text(
                          (product.location?.toString().trim().isNotEmpty ?? false)
                              ? product.location.toString()
                              : "لا يوجد",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.textStyle10W400Green,
                        ),
                      ),
                    ],
                  ),
                  const CustomSizedBox(height: 4,),
                  Row(
                    children: [
                      const Text("النوع ", style: AppStyles.textStyle10W400Gray,),
                      Expanded(
                        child: Text(product.type ?? "-",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.textStyle10W400Yellow,
                        ),
                      ),
                      const Text("الاثاث ", style: AppStyles.textStyle10W400Gray,),
                      Text(product.model ?? "-",
                        style: AppStyles.textStyle10W400Yellow,
                      ),
                    ],
                  ),
                  const CustomSizedBox(height: 6,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(product.price ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainColor,
                          )),
                      ),
                      Text(product.createdAt ?? '',
                        style: AppStyles.textStyle10W400Green.copyWith(
                          color: const Color(0xff7A7A7A),
                        ),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
