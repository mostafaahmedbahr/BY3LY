import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/product_cards.dart';
import 'package:by3ly/features/allSubCategoriesProducts/data/models/all_sub_categories_products_model.dart';
import 'package:flutter/material.dart';

class AllSubCategoriesProductsListItem extends StatelessWidget {
  const AllSubCategoriesProductsListItem({super.key, required this.product});
  final Products product;
  @override
  Widget build(BuildContext context) {
    return ProductGridCard(
      imageUrl: product.image ?? '',
      title: product.name ?? '',
      location: product.location?.toString(),
      type: product.type,
      model: product.model,
      price: product.price?.toString(),
      date: product.createdAt?.toString(),
      rating: product.rate?.toString(),
      productId: product.id,
      initialIsFavourite: product.isFavourite == true,
      onTap: () {
        context.pushNamed(Routes.productDetailsView, arguments: {
          "type": "home",
          "productId": product.id ?? 0,
        });
      },
    );
  }
}
