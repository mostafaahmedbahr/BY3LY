import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/product_badges.dart';
import 'package:by3ly/core/shared_widgets/product_cards.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/productSeller/data/models/product_seller_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// Shared product list used by both the "live now" and "previously sold"
/// tabs — null-safe, animated, identical to every other product strip.
///
/// Emitted as a [SliverList] so the parent CustomScrollView builds only the
/// visible rows (the old `ListView(shrinkWrap: true)` built all of them).
class SellerProductsList extends StatelessWidget {
  const SellerProductsList({super.key, required this.products});

  final List<Products>? products;

  @override
  Widget build(BuildContext context) {
    final items = products ?? const <Products>[];
    if (items.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Icon(
              Icons.inventory_2_outlined,
              size: 52,
              color: AppColors.border,
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        // Odd indices are the 10px separators, same as the old
        // ListView.separated layout.
        if (index.isOdd) return const SizedBox(height: 10);
        final itemIndex = index ~/ 2;
        final item = items[itemIndex];
        // AnimationLimiter renders a RenderBox, so it must wrap each row
        // (not the SliverList itself, which expects RenderSliver children).
        return AnimationLimiter(
          child: AnimationConfiguration.staggeredList(
            position: itemIndex,
            duration: const Duration(milliseconds: 300),
            child: SlideAnimation(
              verticalOffset: 36,
              child: FadeInAnimation(
                child: ProductRowCard(
                  imageUrl: item.image ?? '',
                  title: item.name ?? '',
                  location: item.location,
                  type: item.type,
                  model: item.model,
                  price: item.price,
                  date: item.createdAt,
                  productId: item.id,
                  initialIsFavourite: item.isFavourite == true,
                  isUrgent: item.isUrgent == true,
                  featured: isFeatured(item.status),
                  views: item.views,
                  onTap: () {
                    context.pushNamed(
                      Routes.productDetailsView,
                      arguments: {'type': 'home', 'productId': item.id ?? 0},
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }, childCount: items.length * 2 - 1),
    );
  }
}
