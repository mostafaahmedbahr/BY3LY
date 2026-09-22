import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/related_products_list.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../data/models/product_details_model.dart';
import '../all_related_products_view.dart';

class RelatedProductsWidget extends StatelessWidget {
  const RelatedProductsWidget({super.key, this.relatedProducts});
  final List<RelatedProducts>? relatedProducts;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LocaleKeys.likesProduct.tr(),
              style: AppStyles.textStyle16W600Green,),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child:   AllRelatedProductsView(
                      relatedProducts:relatedProducts,
                    ),
                  ),
                );
              },
              child: Text(LocaleKeys.seeAll.tr(),
                style: AppStyles.textStyle14W500Black,),
            ),
          ],
        ),
        const CustomSizedBox(
          height: 10,
        ),
        RelatedProductsList(
          relatedProductsList:relatedProducts,
        ),
      ],
    );
  }
}
