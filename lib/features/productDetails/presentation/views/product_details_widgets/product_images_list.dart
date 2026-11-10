import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/productDetails/data/models/product_details_model.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_cubit.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Thumbnail strip under the hero. Selected thumb has brand-green frame + glow.
class ProductImagesList extends StatelessWidget {
  const ProductImagesList({super.key, required this.imagesList});

  final List<Images>? imagesList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsStates>(
      builder: (context, state) {
        final productDetailsCubit = ProductDetailsCubit.get(context);
        final images = imagesList ?? const <Images>[];
        if (images.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 66,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              final selected = productDetailsCubit.imageIndex == index;
              final imageUrl = images[index].image.toString();
              return InkWell(
                onTap: () => productDetailsCubit.toggleBetweenImages(index),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  height: 60,
                  width: 60,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: selected
                        ? AppColors.mainColor.withValues(alpha: 0.10)
                        : Colors.transparent,
                    border: Border.all(
                      width: selected ? 2 : 1.2,
                      color: selected
                          ? AppColors.mainColor
                          : AppColors.border,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppColors.mainColor
                                  .withValues(alpha: 0.30),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: CustomNetWorkImage(
                      height: 60,
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      raduis: 0,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) =>
                const CustomSizedBox(width: 10),
            itemCount: images.length,
          ),
        );
      },
    );
  }
}
