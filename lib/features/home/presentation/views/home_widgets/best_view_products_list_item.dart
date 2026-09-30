import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/product_cards.dart';
import 'package:by3ly/features/home/data/models/home_model.dart';
import 'package:flutter/material.dart';

class BestViewProductsListItem extends StatelessWidget {
   const BestViewProductsListItem({super.key, required this.bestView});
   final BestView bestView;
   @override
   Widget build(BuildContext context) {
     return ProductGridCard(
       imageUrl: bestView.image ?? '',
       title: bestView.name ?? '',
       location: bestView.location?.toString(),
       type: bestView.type,
       model: bestView.model,
      price: bestView.price,
      date: bestView.createdAt,
      rating: bestView.rate?.toString(),
       productId: bestView.id,
       initialIsFavourite: bestView.isFavourite == true,
       onTap: () {
         context.pushNamed(Routes.productDetailsView, arguments: {
           "type": "home",
           "productId": bestView.id ?? 0,
         });
       },
     );
   }
}
