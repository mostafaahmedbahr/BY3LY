import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

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
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor: AppColors.mainColor,
        title: Text(
          context.tr(LocaleKeys.ads),
          style: const TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: withImages.isEmpty
          ? Center(
              child: Text(
                context.tr(LocaleKeys.noResults),
                style: const TextStyle(
                  color: AppColors.greyColor,
                  fontSize: 14,
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(20.w),
              itemCount: withImages.length,
              separatorBuilder: (_, __) => Gap(12.h),
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
