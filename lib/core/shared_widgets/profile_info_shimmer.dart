import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_colors/app_colors.dart';

class ProfileInfoShimmer extends StatelessWidget {
  const ProfileInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1E293B) : Colors.grey[300]!,
      highlightColor: isDark ? const Color(0xFF2C3A50) : Colors.grey[100]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Shimmer for avatar
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shimmer for name
                  Container(
                    width: 150,
                    height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Shimmer for progress bar
                  Container(
                    width: 160,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Shimmer for notification icon
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
