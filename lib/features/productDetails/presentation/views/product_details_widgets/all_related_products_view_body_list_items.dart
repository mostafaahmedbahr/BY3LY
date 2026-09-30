import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/product_cards.dart';
import 'package:by3ly/features/productDetails/data/models/product_details_model.dart';
import 'package:flutter/material.dart';

class AllRelatedProductsViewBodyListItems extends StatelessWidget {
  const AllRelatedProductsViewBodyListItems({super.key, this.relatedProducts});
  final List<RelatedProducts>? relatedProducts;
  @override
  Widget build(BuildContext context) {
    return
    GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: relatedProducts?.length ?? 0,
      itemBuilder: (context, index) {
        final item = relatedProducts![index];
        return ProductGridCard(
          imageUrl: item.image ?? '',
          title: item.name ?? '',
          location: item.location?.toString(),
          type: item.type,
          model: item.model,
          price: item.price,
          date: item.createdAt,
          productId: item.id,
          initialIsFavourite: item.isFavourite == true,
          onTap: () {
            context.pushNamed(Routes.productDetailsView, arguments: {
              "type": "home",
              "productId": item.id ?? 0,
            });
          },
        );
      },
    );
  }
}
