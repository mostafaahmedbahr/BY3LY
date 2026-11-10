import 'package:by3ly/core/shared_widgets/container_search_widget.dart';
import 'package:by3ly/features/productDetails/data/models/product_details_model.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/all_related_products_view_body_list_items.dart';
import 'package:flutter/material.dart';

class AllRelatedProductsViewBody extends StatelessWidget {
  const AllRelatedProductsViewBody({super.key, this.relatedProducts});

  final List<RelatedProducts>? relatedProducts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ContainerSearchWidget(),
          const SizedBox(height: 12),
          Expanded(
            child: AllRelatedProductsViewBodyListItems(
              relatedProducts: relatedProducts,
            ),
          ),
        ],
      ),
    );
  }
}
