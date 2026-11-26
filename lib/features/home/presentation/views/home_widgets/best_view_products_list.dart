import 'package:flutter/material.dart';

import '../../../data/models/home_model.dart';
import 'best_view_products_list_item.dart';

/// Lazy grid for the home section.
///
/// The old `GridView.builder(shrinkWrap: true)` inside a ListView had to lay out
/// every card just to measure its height. A [SliverGrid] only builds the cards
/// actually on screen, with identical grid metrics.
class BestViewProductsList extends StatelessWidget {
  const BestViewProductsList({super.key, required this.bestView});

  final List<BestView> bestView;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        // Fixed height instead of an aspect ratio: card content height is
        // mostly constant, so a ratio either overflows on narrow screens
        // or leaves dead space on wide ones.
        mainAxisExtent: 235,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => BestViewProductsListItem(bestView: bestView[index]),
        childCount: bestView.length,
      ),
    );
  }
}
