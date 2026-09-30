import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/fav_heart_button.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/fav/data/models/fav_model.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/shared_widgets/custom_cached_network_image.dart';
import '../../../../../core/shared_widgets/custom_sized_box.dart';
import '../../../../../core/utils/app_styles/app_styles.dart';

class FavItemWidget extends StatelessWidget {
  const FavItemWidget({super.key, required this.favourite});
  final Favourites favourite;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.pushNamed(Routes.productDetailsView, arguments: {
          "type": "home",
          "productId": favourite.id ?? 0,
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
              imageUrl: favourite.image ?? '',
              raduis: 10,
              fit: BoxFit.cover,
              width: 110,
              height: 132,
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
                        child: Text(favourite.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1F2937),
                          ),),
                      ),
                      FavHeartButton(
                        productId: favourite.id,
                        initialIsFavourite: true,
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
                          (favourite.address?.trim().isNotEmpty ?? false)
                              ? favourite.address!
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
                      Text(" ${LocaleKeys.type.tr()}", style: AppStyles.textStyle10W400Gray,),
                      Expanded(
                        child: Text(" ${favourite.type ?? "-"}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.textStyle10W400Yellow,
                        ),
                      ),
                      const Text("الاثاث ", style: AppStyles.textStyle10W400Gray,),
                      Text(" ${favourite.model ?? "-"}",
                        style: AppStyles.textStyle10W400Yellow,
                      ),
                    ],
                  ),
                  const CustomSizedBox(height: 6,),
                  Text(favourite.price ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainColor,
                    )),
                  const CustomSizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(favourite.createdAt ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.textStyle10W400Green.copyWith(
                            color: const Color(0xff7A7A7A),
                          ),),
                      ),
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
