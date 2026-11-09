import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/shared_widgets/product_badges.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/advertisements/data/models/my_ads_data_model.dart';
import 'package:by3ly/features/advertisements/presentation/views/ad_details_view.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_states.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

import 'ad_action_buttons.dart';
import 'ad_options_sheet.dart';
import 'ad_stats_strip.dart';
import 'ad_status_widgets.dart';

class MyAdsListItem extends StatelessWidget {
  const MyAdsListItem({super.key, required this.adsProduct});
  final Ads adsProduct;

  bool get _isActive => adsProduct.isPaused != true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final changed = await Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: AdDetailsView(ad: adsProduct),
          ),
        );
        // Edit/delete inside details refreshes the list on return.
        if (changed == true && context.mounted) {
          AdvertisementsCubit.get(context).fetchMyAds();
        }
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CustomNetWorkImage(
                      imageUrl: adsProduct.image ?? '',
                      raduis: 14,
                      fit: BoxFit.cover,
                      width: 104,
                      height: 118,
                    ),
                    AdImageStatusOverlay(isActive: _isActive),
                  ],
                ),
                const CustomSizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        adsProduct.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.4,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      if (adsProduct.isUrgent == true ||
                          isFeatured(adsProduct.status)) ...[
                        const CustomSizedBox(height: 6),
                        ProductBadges(
                          isUrgent: adsProduct.isUrgent == true,
                          featured: isFeatured(adsProduct.status),
                          elevated: false,
                        ),
                      ],
                      const CustomSizedBox(height: 4),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.location,
                            width: 13,
                            height: 13,
                          ),
                          const CustomSizedBox(width: 4),
                          Expanded(
                            child: Text(
                              (adsProduct.location
                                          ?.toString()
                                          .trim()
                                          .isNotEmpty ??
                                      false)
                                  ? adsProduct.location.toString()
                                  : context.tr(LocaleKeys.noLocation),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const CustomSizedBox(height: 4),
                      Text(
                        [adsProduct.type, adsProduct.model]
                            .where((e) =>
                                (e?.trim().isNotEmpty ?? false))
                            .join('  •  '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const CustomSizedBox(height: 6),
                      Text(
                        adsProduct.price ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      if ((adsProduct.views ?? 0) > 0) ...[
                        const CustomSizedBox(height: 4),
                        ProductViewsLabel(views: adsProduct.views),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AdStatsStrip(
              rate: adsProduct.rate ?? 0,
              comments: adsProduct.countCommenets ?? 0,
              reviews: adsProduct.reviewsCount ?? 0,
            ),
            const SizedBox(height: 10),
            BlocConsumer<AdvertisementsCubit, AdvertisementsStates>(
              listener: (context, state) {
                // Guard by adId: every card listens to the same cubit,
                // only the deleted card shows the toast (otherwise it
                // appears once per visible card).
                if (state is DeleteAdSuccessState &&
                    state.adId == adsProduct.id) {
                  CherryToast.success(
                    title: Text(
                      (state.message?.trim().isNotEmpty ?? false)
                          ? state.message!
                          : context.tr(LocaleKeys.deleteAd),
                      style: const TextStyle(color: AppColors.mainColor),
                    ),
                  ).show(context);
                  // Reload so the page reflects the server state after the
                  // deletion (counts, statuses and remaining ads).
                  AdvertisementsCubit.get(context).fetchMyAds();
                } else if (state is DeleteAdErrorState &&
                    (state.adId == null || state.adId == adsProduct.id)) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                } else if (state is PauseResumeAdSuccessState &&
                    state.adId == adsProduct.id) {
                  final fallback = context.tr(
                    state.isPaused
                        ? LocaleKeys.pauseAd
                        : LocaleKeys.resumeAd,
                  );
                  CherryToast.success(
                    title: Text(
                      (state.message?.trim().isNotEmpty ?? false)
                          ? state.message!
                          : fallback,
                      style: const TextStyle(color: AppColors.mainColor),
                    ),
                  ).show(context);
                } else if (state is PauseResumeAdErrorState &&
                    state.adId == adsProduct.id) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                final deleting = state is DeleteAdLoadingState &&
                    state.adId == adsProduct.id;
                final pausing = state is PauseResumeAdLoadingState &&
                    state.adId == adsProduct.id;
                final busy = deleting || pausing;
                return Row(
                  children: [
                    Expanded(
                      child: AdOptionsButton(
                        onTap: busy
                            ? null
                            : () => showAdOptionsSheet(context, adsProduct),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AdDeleteButton(ad: adsProduct),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
