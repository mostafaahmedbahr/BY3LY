import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/product_cards.dart';
import 'package:by3ly/features/productDetails/data/models/product_details_model.dart';
import 'package:flutter/material.dart';

class RelatedProductsList extends StatelessWidget {
  const RelatedProductsList({super.key,required this.relatedProductsList});
  final List<RelatedProducts>? relatedProductsList;
  @override
  Widget build(BuildContext context) {
    final items = relatedProductsList ?? [];
    if (items.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder:  (context , index ){
          final item = items[index];
          return SizedBox(
            width: 165,
            child: ProductGridCard(
              imageUrl: item.image ?? '',
              title: item.name ?? '',
              location: item.location?.toString(),
              type: item.type,
              model: item.model,
              price: item.price,
              date: item.createdAt,
              rating: item.rate,
              productId: item.id,
              initialIsFavourite: item.isFavourite == true,
              imageHeight: 110,
              onTap: () {
                context.pushNamed(Routes.productDetailsView, arguments: {
                  "type": "home",
                  "productId": item.id ?? 0,
                });
              },
            ),
          );
        },
        separatorBuilder: (context , index ){
          return const SizedBox(width: 10,);
        },
        itemCount: items.length,
      ),
    );
  }
}
