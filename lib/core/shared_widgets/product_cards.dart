import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/shared_widgets/fav_heart_button.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ---------------------------------------------------------------------------
// Modern unified product identity used in EVERY place products appear.
//
// Clean white cards, hairline borders, image-forward layout, dark bold
// prices, minimal heart buttons. No heavy shadows, no coloured pills.
// ---------------------------------------------------------------------------

List<BoxShadow> get _cardShadow => [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];

const _cardBorder = BorderSide(color: Color(0xFFF0F0F0), width: 1);

/// Minimal heart: white circle, hairline frame (always), grey outline
/// heart that flips to a solid red heart instantly on toggle.
class _MinimalHeart extends StatefulWidget {
  const _MinimalHeart({
    required this.productId,
    required this.initialIsFavourite,
    this.size = 32,
    this.iconSize = 18,
  });

  final int? productId;
  final bool initialIsFavourite;
  final double size;
  final double iconSize;

  @override
  State<_MinimalHeart> createState() => _MinimalHeartState();
}

class _MinimalHeartState extends State<_MinimalHeart> {
  bool? _localFav;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavCubit, FavStates>(
      listener: (context, state) {
        if (state is FavToggleSuccess &&
            state.productId == widget.productId) {
          setState(() => _localFav = state.isNowFavourite);
        } else if (state is FavToggleError) {
          setState(() => _localFav = null);
        }
      },
      builder: (context, state) {
        final cubit = FavCubit.get(context);
        final isFav = _localFav ??
            cubit.isFavourite(widget.productId) ||
                widget.initialIsFavourite;
        return Container(
          height: widget.size,
          width: widget.size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  isFav ? AppColors.redColor : const Color(0xFFE8E8E8),
              width: 1.2,
            ),
          ),
          child: Center(
            child: FavHeartButton(
              productId: widget.productId,
              initialIsFavourite: widget.initialIsFavourite,
              withBackground: false,
              iconSize: widget.iconSize,
            ),
          ),
        );
      },
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
          style: const TextStyle(fontSize: 11, color: Color(0xff9AA0A6)),
        ),
      ),
    ],
  );
}

Widget _ratingChip(String rating) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.star_rounded, size: 14, color: AppColors.yellowColor),
      const SizedBox(width: 2),
      Text(
        rating,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xff1F2937),
        ),
      ),
    ],
  );
}

bool _hasValue(String? v) => v?.trim().isNotEmpty ?? false;

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
    this.rating,
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
  final String? rating;
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
          border: Border.fromBorderSide(_cardBorder),
          boxShadow: _cardShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetWorkImage(
              imageUrl: imageUrl,
              raduis: 12,
              fit: BoxFit.cover,
              width: 104,
              height: 116,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _locationRow(location),
                  const SizedBox(height: 4),
                  Text(
                    [type, model]
                        .where((e) => (e?.trim().isNotEmpty ?? false))
                        .join('  •  '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xff9AA0A6)),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          price ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xff1F2937),
                          ),
                        ),
                      ),
                      if (_hasValue(rating) && rating != '-')
                        _ratingChip(rating!),
                      if (productId != null) ...[
                        const SizedBox(width: 8),
                        _MinimalHeart(
                          productId: productId,
                          initialIsFavourite: initialIsFavourite,
                          size: 34,
                          iconSize: 19,
                        ),
                      ],
                    ],
                  ),
                  if (_hasValue(date)) ...[
                    const SizedBox(height: 2),
                    Text(
                      date!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 10, color: Color(0xffB0B5BB)),
                    ),
                  ],
                  if (bottomWidget != null) ...[
                    const SizedBox(height: 6),
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
/// related...). Image bleeds to the card edges, heart floats on top.
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
    this.rating,
    this.productId,
    this.initialIsFavourite = false,
    this.imageHeight = 120,
    required this.onTap,
  });

  final String imageUrl;
  final String title;
  final String? location;
  final String? type;
  final String? model;
  final String? price;
  final String? date;
  final String? rating;
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.fromBorderSide(_cardBorder),
          boxShadow: _cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: CustomNetWorkImage(
                    imageUrl: imageUrl,
                    raduis: 0,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: imageHeight,
                  ),
                ),
                if (productId != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _MinimalHeart(
                      productId: productId,
                      initialIsFavourite: initialIsFavourite,
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
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1F2937),
                    ),
                  ),
                  const SizedBox(height: 3),
                  _locationRow(location),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          price ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xff1F2937),
                          ),
                        ),
                      ),
                      if (_hasValue(rating) && rating != '-')
                        _ratingChip(rating!),
                    ],
                  ),
                  if (_hasValue(date)) ...[
                    const SizedBox(height: 2),
                    Text(
                      date!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 10, color: Color(0xffB0B5BB)),
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
