import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/product_cards.dart';
import 'package:by3ly/features/search/data/models/all_products_search_model.dart';
import 'package:flutter/material.dart';

class SearchItemWidget extends StatelessWidget {
  const SearchItemWidget({super.key, required this.product});
  final Products product;
  @override
  Widget build(BuildContext context) {
    return ProductRowCard(
      imageUrl: product.image ?? '',
      title: product.name ?? '',
      location: product.location?.toString(),
      type: product.type,
      model: product.model,
      price: product.price,
      date: product.createdAt,
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
