import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetWorkImage extends StatelessWidget {
  const CustomNetWorkImage({Key? key, required this.imageUrl, required this.raduis,
  this.width,
  this.height, this.fit,
  }) : super(key: key);
final String imageUrl;
final double raduis;
final double? height;
final double? width;
final  BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
      borderRadius: BorderRadius.circular(raduis),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height ?? double.infinity,
        width: width ?? double.infinity,
        fit:fit ?? BoxFit.contain,
        placeholder: (context, url) => const Center(child:   CustomLoading()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}