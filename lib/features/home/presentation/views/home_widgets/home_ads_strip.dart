import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../data/models/home_model.dart';
import '../all_ads_view.dart';

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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr(LocaleKeys.ads),
                  style: AppStyles.textStyle16W600Black,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: AllAdsView(ads: ads),
                      ),
                    );
                  },
                  child: Text(
                    context.tr(LocaleKeys.seeAll),
                    style: const TextStyle(
                        color: AppColors.mainColor),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 130.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: visible.length,
              separatorBuilder: (_, __) => Gap(12.w),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CustomNetWorkImage(
                    raduis: 14,
                    width: 250.w,
                    fit: BoxFit.cover,
                    imageUrl: urlsOf(visible[index]).first,
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
