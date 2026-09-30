import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/product_cards.dart';
import 'package:by3ly/features/fav/data/models/fav_model.dart';
import 'package:flutter/material.dart';

class FavItemWidget extends StatelessWidget {
  const FavItemWidget({super.key, required this.favourite});
  final Favourites favourite;
  @override
  Widget build(BuildContext context) {
    return ProductRowCard(
      imageUrl: favourite.image ?? '',
      title: favourite.name ?? '',
      location: favourite.address,
      type: favourite.type,
      model: favourite.model,
      price: favourite.price,
      date: favourite.createdAt,
      productId: favourite.id,
      initialIsFavourite: true,
      onTap: () {
        context.pushNamed(Routes.productDetailsView, arguments: {
          "type": "home",
          "productId": favourite.id ?? 0,
        });
      },
    );
  }
}
