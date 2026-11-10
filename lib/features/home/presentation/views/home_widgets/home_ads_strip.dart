import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../data/models/home_model.dart';
import '../all_ads_view.dart';
import 'section_header.dart';

/// Ads section: title + horizontal scroll of the first 5 ads
/// (first image of each). "See all" opens the full page.
class HomeAdsStrip extends StatelessWidget {
  const HomeAdsStrip({super.key, required this.ads});

  final List<Ads> ads;

  static List<String> urlsOf(Ads ad) {
    final urls = <String>[
      for (final img in (ad.images ?? []))
        if ((img?.image?.trim().isNotEmpty ?? false))
          img!.image!.trim(),
    ];
    if (urls.isEmpty) {
      final single = ad.image?.trim() ?? '';
      if (single.isNotEmpty) urls.add(single);
    }
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    final withImages =
        ads.where((ad) => urlsOf(ad).isNotEmpty).toList();
    if (withImages.isEmpty) return const SizedBox.shrink();
    // First 5 available only.
    final visible = withImages.take(5).toList();
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        children: [
          SectionHeader(
            title: context.tr(LocaleKeys.ads),
            actionLabel: context.tr(LocaleKeys.seeAll),
            onAction: () => Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: AllAdsView(ads: ads),
              ),
            ),
          ),
          SizedBox(
            height: 130.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: visible.length,
              separatorBuilder: (_, _) => Gap(12.w),
              itemBuilder: (context, index) {
                final ad = visible[index];
                final name = ad.name?.trim();
                return SizedBox(
                  width: 250.w,
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CustomNetWorkImage(
                          raduis: 14,
                          width: 250.w,
                          fit: BoxFit.cover,
                          imageUrl: urlsOf(ad).first,
                        ),
                        if (name != null && name.isNotEmpty)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 18, 10, 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.65),
                                  ],
                                ),
                              ),
                              child: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
