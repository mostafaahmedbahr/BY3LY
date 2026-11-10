import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../../core/shared_widgets/custom_sized_box.dart';

/// Skeleton rows that mirror the ProductRowCard geometry
/// (image block on one side, three text lines on the other).
class FavDataListLoading extends StatelessWidget {
  const FavDataListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.separated(
        itemCount: 6,
        padding: const EdgeInsets.symmetric(vertical: 2),
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 700),
            child: const SlideAnimation(
              horizontalOffset: 40.0,
              child: FadeInAnimation(
                child: _FavSkeletonRow(),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const CustomSizedBox(height: 14),
      ),
    );
  }
}

class _FavSkeletonRow extends StatelessWidget {
  const _FavSkeletonRow();

  Widget _line(double widthFactor, double height) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: AlignmentDirectional.centerStart,
      child: SimmerLoading(height: height, raduis: 6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SimmerLoading(
          height: 116,
          width: 104,
          raduis: 12,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(0.85, 13),
                const SizedBox(height: 10),
                _line(0.5, 10),
                const SizedBox(height: 12),
                _line(0.9, 11),
                const SizedBox(height: 12),
                _line(0.45, 14),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
