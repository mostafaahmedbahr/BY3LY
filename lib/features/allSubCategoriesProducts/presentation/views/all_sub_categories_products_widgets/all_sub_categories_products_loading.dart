import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Shimmer skeleton mirroring [AllSubCategoriesProductsListItem]:
/// image block + text lines in a 2-column grid.
class AllSubCategoriesProductsLoading extends StatelessWidget {
  const AllSubCategoriesProductsLoading({super.key, this.itemCount = 10});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: itemCount,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 235,
        ),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(child: SimmerLoading(raduis: 10)),
                SizedBox(height: 8),
                SimmerLoading(height: 12, raduis: 6),
                SizedBox(height: 6),
                SimmerLoading(height: 10, width: 100, raduis: 6),
              ],
            ),
          );
        },
      ),
    );
  }
}
