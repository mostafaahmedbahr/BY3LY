
import 'package:by3ly/core/shared_widgets/app_confirm_dialog.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_cubit.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_states.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:by3ly/features/addAdvertisements/presentation/views/edit_ad_view.dart';

import '../../../../../main_importants.dart';
import '../../../data/models/my_ads_data_model.dart';

class MyAdsListItem extends StatelessWidget {
  const MyAdsListItem({super.key, required this.adsProduct});
  final Ads adsProduct;

  bool get _isActive => adsProduct.isPaused != true;

  Future<void> _showOptionsMenu(
      BuildContext context, Ads ad) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 8),
              _OptionTile(
                icon: Icons.edit_outlined,
                title: "تعديل الاعلان",
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final updated = await Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: EditAdView(ad: ad),
                    ),
                  );
                  if (updated == true && context.mounted) {
                    AdvertisementsCubit.get(context)
                        .getAllMyAdsDataMethod(type: 0);
                  }
                },
              ),
              _OptionTile(
                icon: Icons.delete_outline_rounded,
                title: "حذف الاعلان",
                danger: true,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  if (ad.id == null) return;
                  final confirmed =
                      await AppConfirmDialog.show(
                    context,
                    title: context.tr(LocaleKeys.deleteAd),
                    message:
                        context.tr(LocaleKeys.deleteAdConfirm),
                    confirmText:
                        context.tr(LocaleKeys.deleteAd),
                    icon: Icons.delete_outline_rounded,
                  );
                  if (confirmed && context.mounted) {
                    AdvertisementsCubit.get(context)
                        .deleteAd(adId: ad.id!);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData(
        icon: AppImages.star,
        tint: const Color(0xffFFF4D6),
        label: "التقييم",
        value: adsProduct.rate?.toString() ?? "-",
      ),
      _StatData(
        icon: "assets/images/Chat.svg",
        tint: const Color(0xffE3F2FD),
        label: "التعليقات",
        value: adsProduct.countCommenets?.toString() ?? "-",
      ),
      _StatData(
        icon: "assets/images/eye (1).svg",
        tint: const Color(0xffE6F4EF),
        label: "المراجعات",
        value: adsProduct.reviewsCount?.toString() ?? "-",
      ),
    ];
    return InkWell(
      onTap: () {
        context.pushNamed(Routes.productDetailsView, arguments: {
          "type": "home",
          "productId": adsProduct.id ?? 0,
        });
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFF0F0F0)),
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
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.vertical(
                            bottom: Radius.circular(14),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _isActive
                                    ? const Color(0xff34C759)
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _isActive ? "نشط" : "غير نشط",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const CustomSizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        adsProduct.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.4,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1F2937),
                        ),
                      ),
                      const CustomSizedBox(height: 4,),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.location,
                            width: 13,
                            height: 13,
                          ),
                          const CustomSizedBox(width: 4,),
                          Expanded(
                            child: Text(
                              (adsProduct.location
                                          ?.toString()
                                          .trim()
                                          .isNotEmpty ??
                                      false)
                                  ? adsProduct.location.toString()
                                  : "لا يوجد",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xff9AA0A6)),
                            ),
                          ),
                        ],
                      ),
                      const CustomSizedBox(height: 4,),
                      Text(
                        [adsProduct.type, adsProduct.model]
                            .where((e) =>
                                (e?.trim().isNotEmpty ?? false))
                            .join('  •  '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xff9AA0A6)),
                      ),
                      const CustomSizedBox(height: 6,),
                      Text(
                        adsProduct.price ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12,),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xffF8FAF9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  for (int i = 0; i < stats.length; i++) ...[
                    Expanded(
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: stats[i].tint,
                              borderRadius:
                                  BorderRadius.circular(9),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                stats[i].icon,
                                width: 15,
                                height: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                stats[i].value,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff1F2937),
                                ),
                              ),
                              Text(
                                stats[i].label,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff9AA0A6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (i != stats.length - 1)
                      Container(
                        width: 1,
                        height: 34,
                        color: const Color(0xFFE5E7EB),
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10,),
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
                      style: const TextStyle(
                          color: AppColors.mainColor),
                    ),
                  ).show(context);
                } else if (state is DeleteAdErrorState &&
                    (state.adId == null ||
                        state.adId == adsProduct.id)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                final deleting = state is DeleteAdLoadingState &&
                    state.adId == adsProduct.id;
                return Row(
                  children: [
                    Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showOptionsMenu(context, adsProduct),
                      icon: const Icon(
                        Icons.settings_outlined,
                        size: 18,
                        color: AppColors.mainColor,
                      ),
                        label: const Text(
                          "خيارات",
                          style: TextStyle(
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: AppColors.mainColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 11),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12,),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: deleting
                            ? null
                            : () async {
                                if (adsProduct.id == null) return;
                                final confirmed =
                                    await AppConfirmDialog.show(
                                  context,
                                  title: context
                                      .tr(LocaleKeys.deleteAd),
                                  message: context.tr(
                                      LocaleKeys.deleteAdConfirm),
                                  confirmText: context
                                      .tr(LocaleKeys.deleteAd),
                                  icon:
                                      Icons.delete_outline_rounded,
                                );
                                if (confirmed &&
                                    context.mounted) {
                                  AdvertisementsCubit.get(context)
                                      .deleteAd(
                                          adId: adsProduct.id!);
                                }
                              },
                        icon: deleting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                        label: Text(
                          context.tr(LocaleKeys.deleteAd),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redColor,
                          disabledBackgroundColor: AppColors.redColor
                              .withValues(alpha: 0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 11),
                          elevation: 0,
                        ),
                      ),
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

class _StatData {
  final String icon;
  final Color tint;
  final String label;
  final String value;

  const _StatData({
    required this.icon,
    required this.tint,
    required this.label,
    required this.value,
  });
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color =
        danger ? AppColors.redColor : AppColors.mainColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1F2937),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Color(0xffD9DEE3),
            ),
          ],
        ),
      ),
    );
  }
}
