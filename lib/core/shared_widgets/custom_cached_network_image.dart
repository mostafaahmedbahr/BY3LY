import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetWorkImage extends StatelessWidget {
  const CustomNetWorkImage({
    super.key,
    required this.imageUrl,
    required this.raduis,
    this.width,
    this.height,
    this.fit,
  });
  final String imageUrl;
  final double raduis;
  final double? height;
  final double? width;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Bound the decoded bitmap to what is actually drawn on screen.
        // Only the memory cache is limited: the original stays in the disk
        // cache so the same URL isn't downloaded again at another size.
        double? bounded(double? value, bool hasMax, double max) {
          if (value != null && value.isFinite && value > 0) return value;
          if (hasMax && max.isFinite && max > 0) return max;
          return null;
        }

        final targetWidth = bounded(
          width,
          constraints.hasBoundedWidth,
          constraints.maxWidth,
        );
        final targetHeight = bounded(
          height,
          constraints.hasBoundedHeight,
          constraints.maxHeight,
        );

        return ClipRRect(
          borderRadius: BorderRadius.circular(raduis),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            height: height ?? double.infinity,
            width: width ?? double.infinity,
            fit: fit ?? BoxFit.contain,
            memCacheWidth: targetWidth == null
                ? null
                : (targetWidth * pixelRatio).round(),
            memCacheHeight: targetHeight == null
                ? null
                : (targetHeight * pixelRatio).round(),
            placeholder: (context, url) =>
                SimmerLoading(height: height, width: width, raduis: raduis),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        );
      },
    );
  }
}
