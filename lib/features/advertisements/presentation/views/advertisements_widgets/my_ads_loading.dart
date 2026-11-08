import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Shimmer skeleton mirroring [MyAdsListItem]: image block + text lines.
///
/// A plain column (no inner scroll view) so it can live inside the page's
/// single pull-to-refresh [ListView].
class MyAdsLoading extends StatelessWidget {
  const MyAdsLoading({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < itemCount; i++) ...[
          if (i > 0) const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SimmerLoading(height: 118, width: 104, raduis: 12),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SimmerLoading(height: 14, raduis: 6),
                      SizedBox(height: 8),
                      SimmerLoading(height: 11, width: 120, raduis: 6),
                      SizedBox(height: 8),
                      SimmerLoading(height: 11, width: 160, raduis: 6),
                      SizedBox(height: 12),
                      SimmerLoading(height: 18, width: 90, raduis: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
