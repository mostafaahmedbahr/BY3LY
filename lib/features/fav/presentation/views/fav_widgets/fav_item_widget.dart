import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
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
      child: Row(
        children: [
          CustomNetWorkImage(
            imageUrl: favourite.image ?? '',
            raduis: 10,
            fit: BoxFit.cover,
            width: 175,
            height: 120,
          ),
          const  CustomSizedBox(width: 10,),
          Expanded(
            child: SizedBox(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(favourite.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff000000),
                    ),),
                  Row(
                    children: [
                      SvgPicture.asset(AppImages.location),
                      const  CustomSizedBox(width: 5,),
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
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(" ${LocaleKeys.type.tr()}",style: AppStyles.textStyle10W400Gray,),
                          Text(" ${favourite.type ?? "-"}",style: AppStyles.textStyle10W400Yellow,),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("الاثاث ",style: AppStyles.textStyle10W400Gray,),
                          Text(" ${favourite.model ?? "-"}",style: AppStyles.textStyle10W400Yellow,),
                        ],
                      ),
                    ],
                  ),
                  Text(favourite.price ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
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
                      InkWell(
                        onTap: (){
                          if (favourite.id != null) {
                            FavCubit.get(context).removeProductFromFav(
                                productId: favourite.id!);
                          }
                        },
                        child: Text(LocaleKeys.removerFromFav.tr(),
                          style: AppStyles.textStyle12W600Gary.copyWith(
                            color: AppColors.redColor,
                          ),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
