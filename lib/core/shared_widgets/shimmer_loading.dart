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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      // Calm, soft loading shimmer (no harsh grey/teal flashing).
      baseColor: isDark
          ? const Color(0xFF1E293B)
          : const Color(0xFFECEFF1),
      highlightColor: isDark
          ? const Color(0xFF2C3A50)
          : const Color(0xFFFAFBFC),
      period: const Duration(milliseconds: 1600),
      child: Container(
        width: width ?? double.infinity,
        height: height?? double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(raduis ?? 10),
        ),
      ),
    );
  }
}
