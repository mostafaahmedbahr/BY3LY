import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_colors/app_colors.dart';


class SimmerLoading extends StatelessWidget {
  const SimmerLoading({super.key,   this.height,   this.width,   this.raduis});
  final double? height;
  final double? width;
  final double? raduis;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      // Calm, soft loading shimmer (no harsh grey/teal flashing).
      baseColor: const Color(0xFFECEFF1),
      highlightColor: const Color(0xFFFAFBFC),
      period: const Duration(milliseconds: 1600),
      child: Container(
        width: width ?? double.infinity,
        height: height?? double.infinity,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(raduis ?? 10),
        ),
      ),
    );
  }
}
