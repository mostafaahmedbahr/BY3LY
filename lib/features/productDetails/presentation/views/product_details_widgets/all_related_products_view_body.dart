import 'package:by3ly/core/shared_widgets/container_search_widget.dart';
import 'package:by3ly/main_importants.dart';

import '../../../data/models/product_details_model.dart';
import 'all_related_products_view_body_list_items.dart';

class AllRelatedProductsViewBody extends StatelessWidget {
  const AllRelatedProductsViewBody({super.key, this.relatedProducts});
  final List<RelatedProducts>? relatedProducts;
  @override
  Widget build(BuildContext context) {
    return   Column(
      children: [
        const ContainerSearchWidget(),
        const SizedBox(height: 20,),
        AllRelatedProductsViewBodyListItems(
          relatedProducts: relatedProducts,
        ),

      ],
    );
  }
}
