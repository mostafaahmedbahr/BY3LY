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
class SellerProductsList extends StatelessWidget {
  const SellerProductsList({super.key, required this.products});

  final List<Products>? products;

  @override
  Widget build(BuildContext context) {
    final items = products ?? const <Products>[];
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Icon(
            Icons.inventory_2_outlined,
            size: 52,
            color: AppColors.border,
          ),
        ),
      );
    }

    return AnimationLimiter(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          return AnimationConfiguration.staggeredList(
            position: index,
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
                      arguments: {
                        'type': 'home',
                        'productId': item.id ?? 0,
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
