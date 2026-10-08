import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Shimmer skeleton mirroring the product details page:
/// image, thumbnails, title, seller, rating, buttons, related items.
class ProductDetailsLoading extends StatelessWidget {
  const ProductDetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor: AppColors.mainColor,
        title: const SimmerLoading(height: 18, width: 140, raduis: 8),
        actions: const [
          SimmerLoading(height: 36, width: 36, raduis: 18),
          SizedBox(width: 8),
          SimmerLoading(height: 36, width: 36, raduis: 18),
          SizedBox(width: 12),
        ],
      ),
      body: ListView(
        children: [
          // Main image.
          const SimmerLoading(height: 300, raduis: 0),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnails.
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: 10),
                    itemBuilder: (_, _) => const SimmerLoading(
                        height: 60, width: 60, raduis: 10),
                  ),
                ),
                const SizedBox(height: 10),
                // Title + location + price.
                const SimmerLoading(height: 20, raduis: 8),
                const SizedBox(height: 10),
                const SimmerLoading(height: 12, width: 150, raduis: 6),
                const SizedBox(height: 10),
                const SimmerLoading(height: 22, width: 110, raduis: 8),
                const SizedBox(height: 10),
                // Seller row.
                const Row(
                  children: [
                    SimmerLoading(height: 44, width: 44, raduis: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: SimmerLoading(height: 16, raduis: 8),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Rating box.
                const SimmerLoading(height: 56, raduis: 16),
                const SizedBox(height: 10),
                // About + description lines.
                const SimmerLoading(height: 18, width: 120, raduis: 8),
                const SizedBox(height: 10),
                const SimmerLoading(height: 13, raduis: 6),
                const SizedBox(height: 6),
                const SimmerLoading(height: 13, raduis: 6),
                const SizedBox(height: 6),
                const SimmerLoading(
                    height: 13, width: 200, raduis: 6),
                const SizedBox(height: 20),
                // Action buttons.
                const SimmerLoading(height: 48, raduis: 10),
                const SizedBox(height: 20),
                const SimmerLoading(height: 48, raduis: 10),
                const SizedBox(height: 20),
                // Related items.
                const SimmerLoading(height: 18, width: 140, raduis: 8),
                const SizedBox(height: 10),
                SizedBox(
                  height: 230,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: 10),
                    itemBuilder: (_, _) => const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SimmerLoading(
                            height: 110, width: 165, raduis: 12),
                        SizedBox(height: 8),
                        SimmerLoading(
                            height: 12, width: 140, raduis: 6),
                        SizedBox(height: 6),
                        SimmerLoading(
                            height: 12, width: 90, raduis: 6),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
