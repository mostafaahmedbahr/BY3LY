import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/shared_widgets/product_badges.dart';
import 'package:by3ly/core/shared_widgets/product_cards.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/compare/data/models/compare_model.dart';
import 'package:by3ly/features/compare/presentation/view_model/compare_cubit.dart';
import 'package:flutter/material.dart';

List<BoxShadow> get _cardShadow => [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];

/// Product header for the compare table — the exact same visual language
/// as [ProductGridCard] (image bleed, urgent/featured badges, minimal white
/// heart, title, location, price + rating chip, date + views) plus a small
/// remove-from-compare (X) circle next to the heart.
///
/// Tapping the card opens the product details screen.
class ProductHeader extends StatelessWidget {
  const ProductHeader({super.key, required this.product});

  final CompareProduct product;

  bool _hasValue(String? v) => v?.trim().isNotEmpty ?? false;

  void _openDetails(BuildContext context) {
    if (product.id == null) return;
    context.pushNamed(
      Routes.productDetailsView,
      arguments: {'type': 'home', 'productId': product.id!},
    );
  }

  @override
  Widget build(BuildContext context) {
    final isListingFeatured = isFeatured(product.status);
    final price = product.price?.trim();
    final date = product.date ?? product.createdAt;
    final viewsCount = product.views ?? 0;

    return InkWell(
      onTap: () => _openDetails(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: _cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: CustomNetWorkImage(
                    imageUrl: product.image ?? '',
                    raduis: 0,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 120,
                  ),
                ),
                // Urgent / featured badges — leave room for the two circles.
                if (product.isUrgent == true || isListingFeatured)
                  Positioned(
                    top: 8,
                    left: 8,
                    right: 84,
                    child: ProductBadges(
                      isUrgent: product.isUrgent == true,
                      featured: isListingFeatured,
                    ),
                  ),
                // Remove from compare (X) — left of the heart.
                Positioned(
                  top: 8,
                  right: 48,
                  child: _RemoveButton(
                    onTap: () => CompareCubit.get(context)
                        .removeFromBasket(product.id ?? -1),
                  ),
                ),
                // Favourite heart — same minimal white circle as product cards.
                if (product.id != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: MinimalHeart(
                      productId: product.id,
                      initialIsFavourite: product.isFavourite == true,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fixed title height (2 lines) so the two columns stay even.
                  SizedBox(
                    height: 32,
                    child: Text(
                      product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  if (_hasValue(product.location)) ...[
                    const SizedBox(height: 3),
                    locationRow(product.location),
                  ],
                  const SizedBox(height: 4),
                  // type • model — same one-liner as the product cards.
                  if (_hasValue(product.type) || _hasValue(product.model)) ...[
                    Text(
                      [product.type, product.model]
                          .where(_hasValue)
                          .join('  •  '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (_hasValue(price) || _hasValue(product.rate)) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            price ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        if (_hasValue(product.rate) && product.rate != '-')
                          ratingChip(product.rate!),
                      ],
                    ),
                  ],
                  if (_hasValue(date) || viewsCount > 0) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (_hasValue(date))
                          Expanded(
                            child: Text(
                              date!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        if (viewsCount > 0) ProductViewsLabel(views: viewsCount),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small white circle with a red close icon — removes the product from
/// the comparison basket. Same visual language as [MinimalHeart].
class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: CircleBorder(
        side: BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.click,
        child: const SizedBox(
          height: 32,
          width: 32,
          child: Center(
            child: Icon(Icons.close_rounded, size: 16, color: AppColors.redColor),
          ),
        ),
      ),
    );
  }
}
