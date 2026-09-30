import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/shared_widgets/fav_heart_button.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ---------------------------------------------------------------------------
// Unified product identity used in EVERY place products appear.
// Signature look: soft 16-radius white card, cover image, price pill
// floating over the image, heart in a white circular button.
// ---------------------------------------------------------------------------

List<BoxShadow> get _cardShadow => [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.07),
        blurRadius: 12,
        offset: const Offset(0, 3),
      ),
    ];

/// Small white pill carrying the price, floating over the image bottom.
class _PricePill extends StatelessWidget {
  const _PricePill({required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        price,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.mainColor,
        ),
      ),
    );
  }
}

/// White circular heart button with a soft shadow.
class _HeartBubble extends StatelessWidget {
  const _HeartBubble({
    required this.productId,
    required this.initialIsFavourite,
  });

  final int? productId;
  final bool initialIsFavourite;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        // Permanent frame around the heart mark.
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: FavHeartButton(
          productId: productId,
          initialIsFavourite: initialIsFavourite,
          withBackground: false,
          iconSize: 18,
        ),
      ),
    );
  }
}

/// Framed heart for row cards: white circle with a permanent frame.
class _FramedHeart extends StatelessWidget {
  const _FramedHeart({
    required this.productId,
    required this.initialIsFavourite,
  });

  final int? productId;
  final bool initialIsFavourite;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: FavHeartButton(
          productId: productId,
          initialIsFavourite: initialIsFavourite,
          withBackground: false,
          iconSize: 19,
        ),
      ),
    );
  }
}

Widget _locationRow(String? location) {
  return Row(
    children: [
      SvgPicture.asset(
        AppImages.location,
        width: 13,
        height: 13,
      ),
      const SizedBox(width: 4),
      Expanded(
        child: Text(
          (location?.trim().isNotEmpty ?? false) ? location! : "لا يوجد",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.textStyle10W400Green,
        ),
      ),
    ],
  );
}

/// Shared horizontal product card used everywhere products are listed
/// in rows (search, favourites, seller products...).
class ProductRowCard extends StatelessWidget {
  const ProductRowCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.location,
    this.type,
    this.model,
    this.price,
    this.date,
    this.productId,
    this.initialIsFavourite = false,
    this.bottomWidget,
    required this.onTap,
  });

  final String imageUrl;
  final String title;
  final String? location;
  final String? type;
  final String? model;
  final String? price;
  final String? date;
  final int? productId;
  final bool initialIsFavourite;

  /// Optional extra row at the bottom (e.g. remove-from-fav action).
  final Widget? bottomWidget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _cardShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CustomNetWorkImage(
                  imageUrl: imageUrl,
                  raduis: 12,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 112,
                ),
                if ((price?.trim().isNotEmpty ?? false))
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: _PricePill(price: price!),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff1F2937),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (productId != null)
                        _FramedHeart(
                          productId: productId,
                          initialIsFavourite: initialIsFavourite,
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  _locationRow(location),
                  const SizedBox(height: 3),
                  Text(
                    [type, model]
                        .where((e) => (e?.trim().isNotEmpty ?? false))
                        .join(' • '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.textStyle10W400Gray,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.textStyle10W400Green.copyWith(
                      color: const Color(0xff9AA0A6),
                    ),
                  ),
                  if (bottomWidget != null) ...[
                    const SizedBox(height: 4),
                    bottomWidget!,
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

/// Shared vertical product card used everywhere products are shown
/// in grids / horizontal lists (home best-view, sub-category, see-all,
/// related...). Price pill floats over the image, heart in a white bubble.
class ProductGridCard extends StatelessWidget {
  const ProductGridCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.location,
    this.type,
    this.model,
    this.price,
    this.date,
    this.productId,
    this.initialIsFavourite = false,
    this.imageHeight = 128,
    required this.onTap,
  });

  final String imageUrl;
  final String title;
  final String? location;
  final String? type;
  final String? model;
  final String? price;
  final String? date;
  final int? productId;
  final bool initialIsFavourite;
  final double imageHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                CustomNetWorkImage(
                  imageUrl: imageUrl,
                  raduis: 12,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: imageHeight,
                ),
                // Soft bottom scrim so the pill + heart sit comfortably.
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.10),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                ),
                if (productId != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _HeartBubble(
                      productId: productId,
                      initialIsFavourite: initialIsFavourite,
                    ),
                  ),
                if ((price?.trim().isNotEmpty ?? false))
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: _PricePill(price: price!),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                height: 1.35,
                fontWeight: FontWeight.w500,
                color: Color(0xff1F2937),
              ),
            ),
            const SizedBox(height: 4),
            _locationRow(location),
            const SizedBox(height: 2),
            Text(
              [type, model]
                  .where((e) => (e?.trim().isNotEmpty ?? false))
                  .join(' • '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.textStyle10W400Gray,
            ),
            if (date?.trim().isNotEmpty ?? false) ...[
              const SizedBox(height: 2),
              Text(
                date!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.textStyle10W400Green.copyWith(
                  color: const Color(0xff9AA0A6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
