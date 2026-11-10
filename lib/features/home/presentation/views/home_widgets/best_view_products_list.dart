import 'package:flutter/material.dart';

import '../../../data/models/home_model.dart';
import 'best_view_products_list_item.dart';

class BestViewProductsList extends StatelessWidget {
  const BestViewProductsList({super.key, required this.bestView});

  final List<BestView> bestView;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        // Fixed height instead of an aspect ratio: card content height is
        // mostly constant, so a ratio either overflows on narrow screens
        // or leaves dead space on wide ones.
        mainAxisExtent: 235,
      ),
      itemCount: bestView.length,
      itemBuilder: (context, index) =>
          BestViewProductsListItem(bestView: bestView[index]),
    );
  }
}
