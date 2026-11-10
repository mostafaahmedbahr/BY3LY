import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Full-page skeleton mirroring the wallet screen layout
/// (balance card + package card + history rows).
class WalletPageShimmer extends StatelessWidget {
  const WalletPageShimmer({super.key});

  static const int _historySkeletons = 4;

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SimmerLoading(height: 124, raduis: 22),
        SizedBox(height: 12),
        SimmerLoading(height: 84, raduis: 18),
        SizedBox(height: 20),
        SimmerLoading(height: 16, width: 150, raduis: 6),
        SizedBox(height: 12),
        _HistorySkeleton(),
      ],
    );
  }
}

class _HistorySkeleton extends StatelessWidget {
  const _HistorySkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < WalletPageShimmer._historySkeletons; i++) ...[
          if (i > 0) const CustomSizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                SimmerLoading(height: 46, width: 46, raduis: 14),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: SimmerLoading(height: 13, raduis: 6)),
                          SizedBox(width: 12),
                          SimmerLoading(height: 13, width: 56, raduis: 6),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SimmerLoading(height: 10, width: 70, raduis: 5),
                          Spacer(),
                          SimmerLoading(height: 10, width: 50, raduis: 5),
                        ],
                      ),
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
