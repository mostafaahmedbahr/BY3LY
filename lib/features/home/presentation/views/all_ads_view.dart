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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        shadowColor: AppColors.mainColor,
        surfaceTintColor: AppColors.mainColor,
        title: Text(
          context.tr(LocaleKeys.ads),
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
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
