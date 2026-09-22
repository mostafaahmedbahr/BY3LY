 import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/all_related_products_view_body.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/product_details_model.dart';

class AllRelatedProductsView extends StatelessWidget {
  const AllRelatedProductsView({super.key,required this.relatedProducts});
  final List<RelatedProducts>? relatedProducts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title:  Text(LocaleKeys.likesProduct.tr(),
          style: AppStyles.textStyle16W600Green,),
      ),
      body:      Padding(
        padding: const EdgeInsets.all(20.0),
        child: AllRelatedProductsViewBody(
          relatedProducts: relatedProducts,
        ),
      ),
    );
  }
}
