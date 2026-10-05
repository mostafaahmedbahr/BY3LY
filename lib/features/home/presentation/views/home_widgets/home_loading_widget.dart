import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/shared_widgets/shimmer_loading.dart';
import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../../../../core/utils/app_styles/app_styles.dart';
import '../../../../../lang/locale_keys.dart';

/// Loading skeleton that mirrors [HomeViewBody] section by section
/// (slider -> search -> categories -> login banner -> best-view grid)
/// with the same sizes, so the screen doesn't jump when data arrives.
class HomeLoadingWidget extends StatelessWidget {
  const HomeLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        /// 1. Banner slider skeleton (same size as the real carousel).
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: SimmerLoading(height: 185, raduis: 22),
        ),

        /// 2. Search bar skeleton.
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: SimmerLoading(height: 52, raduis: 12),
        ),

        /// 3. Categories skeleton.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr(LocaleKeys.categories),
                    style: AppStyles.textStyle16W600Black,
                  ),
                  Text(
                    context.tr(LocaleKeys.seeAll),
                    style: const TextStyle(color: AppColors.mainColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: 25),
                  itemBuilder: (_, _) => const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SimmerLoading(height: 50, width: 60, raduis: 10),
                      SizedBox(height: 6),
                      SimmerLoading(height: 12, width: 48, raduis: 6),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        /// 4. Login banner skeleton (full-bleed like the real banner).
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: SimmerLoading(height: 118, raduis: 0),
        ),

        /// 5. Best-view grid skeleton (same grid metrics as the real one).
        Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr(LocaleKeys.bestView),
                    style: AppStyles.textStyle16W600Black,
                  ),
                  Text(
                    context.tr(LocaleKeys.seeAll),
                    style: const TextStyle(color: AppColors.mainColor),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 235,
                ),
                itemCount: 6,
                itemBuilder: (_, _) => const _ProductCardSkeleton(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Skeleton shaped like a product card: image block + text lines.
class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: SimmerLoading(height: 140, raduis: 0),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SimmerLoading(height: 12, raduis: 6),
                SizedBox(height: 6),
                SimmerLoading(height: 10, width: 90, raduis: 6),
                SizedBox(height: 6),
                SimmerLoading(height: 14, width: 70, raduis: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
