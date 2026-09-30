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
      child: Row(
        children: [
            CustomNetWorkImage(
            imageUrl: "${product.image}",
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
                   Text( "${product.name}",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text("النوع ",style: AppStyles.textStyle10W400Gray,),
                          Text(" ${product.type ?? "-"}",style: AppStyles.textStyle10W400Yellow,),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("الاثاث ",style: AppStyles.textStyle10W400Gray,),
                          Text(" ${product.model ?? "-"}", style: AppStyles.textStyle10W400Yellow,),
                        ],
                      ),
                    ],
                  ),
                   Text( "${product.price}",
                      style:const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  Text( "${product.createdAt}",
                    style: AppStyles.textStyle10W400Green.copyWith(
                      color: const Color(0xff7A7A7A),
                    ),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
