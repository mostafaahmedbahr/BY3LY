import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../data/models/home_model.dart';
import 'home_widgets/banner_ads.dart';
import 'home_widgets/home_ads_strip.dart';

/// Full ads list page: every ad with its own slider.
class AllAdsView extends StatelessWidget {
  const AllAdsView({super.key, required this.ads});

  final List<Ads> ads;

  @override
  Widget build(BuildContext context) {
    final withImages =
        ads.where((ad) => HomeAdsStrip.urlsOf(ad).isNotEmpty).toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.darkMainColor,
                AppColors.mainColor,
                AppColors.secondColor,
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
              child: const Icon(
                Icons.campaign_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                context.tr(LocaleKeys.ads),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
      body: withImages.isEmpty
          ? Center(
              child: Text(
                context.tr(LocaleKeys.noResults),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(20.w),
              itemCount: withImages.length,
              separatorBuilder: (_, _) => Gap(12.h),
              itemBuilder: (context, index) {
                return BannerAds(
                  imageUrls:
                      HomeAdsStrip.urlsOf(withImages[index]),
                );
              },
            ),
    );
  }
}
