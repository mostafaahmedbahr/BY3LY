import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../core/shared_widgets/custom_cached_network_image.dart';
import '../../../../../core/shared_widgets/custom_sized_box.dart';
import '../../../../../core/utils/app_styles/app_styles.dart';
import '../../../../productDetails/presentation/views/product_details_view.dart';

class FavItemWidget extends StatelessWidget {
  const FavItemWidget({super.key, required this.productId});
  final int productId;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child:   const ProductDetailsView(
              productId: 1,
              type: "home",
            ),
          ),
        );
      },
      child: Row(
        children: [
          const CustomNetWorkImage(
            imageUrl: AppImages.testImage,
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
                  const Text("فيلا للايجار اليومي والشهري",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff000000),
                    ),),
                  Row(
                    children: [
                      SvgPicture.asset(AppImages.location),
                      const  CustomSizedBox(width: 5,),
                      const Text("مدينة نصر",style: AppStyles.textStyle10W400Green,),
                    ],
                  ),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(" ${LocaleKeys.type.tr()}",style: AppStyles.textStyle10W400Gray,),
                          const Text(" ايجار",style: AppStyles.textStyle10W400Yellow,),
                        ],
                      ),
                      const Row(
                        children: [
                          Text("الاثاث ",style: AppStyles.textStyle10W400Gray,),
                          Text(" مفروشة",style: AppStyles.textStyle10W400Yellow,),
                        ],
                      ),
                    ],
                  ),
                  const Text("250,000 LE",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("منذ واحد يوم ",
                        style: AppStyles.textStyle10W400Green.copyWith(
                          color: const Color(0xff7A7A7A),
                        ),),
                      InkWell(
                        onTap: (){
                          FavCubit.get(context).removeProductFromFav(productId: productId);
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
