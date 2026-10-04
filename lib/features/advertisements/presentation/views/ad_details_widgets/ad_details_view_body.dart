import 'package:by3ly/core/shared_widgets/app_confirm_dialog.dart';
import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/shared_widgets/full_screen_gallery.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/features/addAdvertisements/presentation/views/edit_ad_view.dart';
import 'package:by3ly/features/advertisements/data/models/my_ads_data_model.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_cubit.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class AdDetailsViewBody extends StatefulWidget {
  const AdDetailsViewBody({super.key, required this.ad});

  final Ads ad;

  @override
  State<AdDetailsViewBody> createState() => _AdDetailsViewBodyState();
}

class _AdDetailsViewBodyState extends State<AdDetailsViewBody> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> get _gallery {
    final urls = <String>[
      for (final img in widget.ad.images ?? <Images>[])
        if ((img.image?.trim().isNotEmpty ?? false)) img.image!.trim(),
    ];
    if (urls.isEmpty &&
        (widget.ad.image?.trim().isNotEmpty ?? false)) {
      urls.add(widget.ad.image!.trim());
    }
    return urls;
  }

  bool get _isActive => widget.ad.isPaused != true;

  Future<void> _onEdit() async {
    final updated = await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: EditAdView(ad: widget.ad),
      ),
    );
    if (updated == true && mounted) {
      // Refresh the ads list behind, then close with true so the
      // caller refreshes as well.
      AdvertisementsCubit.get(context)
          .getAllMyAdsDataMethod(type: 0);
      Navigator.pop(context, true);
    }
  }

  Future<void> _onDelete() async {
    final adId = widget.ad.id;
    if (adId == null) return;
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.tr(LocaleKeys.deleteAd),
      message: context.tr(LocaleKeys.deleteAdConfirm),
      confirmText: context.tr(LocaleKeys.deleteAd),
      icon: Icons.delete_outline_rounded,
    );
    if (confirmed && mounted) {
      AdvertisementsCubit.get(context).deleteAd(adId: adId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdvertisementsCubit, AdvertisementsStates>(
      listener: (context, state) {
        if (state is DeleteAdSuccessState) {
          CherryToast.success(
            title: Text(
              (state.message?.trim().isNotEmpty ?? false)
                  ? state.message!
                  : context.tr(LocaleKeys.deleteAd),
              style:
                  const TextStyle(color: AppColors.mainColor),
            ),
          ).show(context);
          Navigator.pop(context, true);
        } else if (state is DeleteAdErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Gallery (tap to open fullscreen).
          Stack(
            children: [
              InkWell(
                onTap: () => FullScreenGallery.open(
                  context,
                  images: _gallery,
                  initialIndex: _pageIndex,
                ),
                child: SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: _gallery.isEmpty
                      ? const CustomNetWorkImage(
                          imageUrl: '',
                          raduis: 16,
                          fit: BoxFit.cover,
                        )
                      : PageView.builder(
                          controller: _pageController,
                          itemCount: _gallery.length,
                          onPageChanged: (i) =>
                              setState(() => _pageIndex = i),
                          itemBuilder: (context, i) =>
                              CustomNetWorkImage(
                            imageUrl: _gallery[i],
                            raduis: 16,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isActive
                        ? AppColors.mainColor
                        : const Color(0xff9AA0A6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _isActive ? "نشط" : "غير نشط",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_gallery.length > 1)
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < _gallery.length; i++)
                        Container(
                          width: _pageIndex == i ? 20 : 7,
                          height: 7,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 3),
                          decoration: BoxDecoration(
                            color: _pageIndex == i
                                ? AppColors.mainColor
                                : Colors.white.withValues(
                                    alpha: 0.7),
                            borderRadius:
                                BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          // Title + price.
          Text(
            widget.ad.name ?? '',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xff1F2937),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.ad.price ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.mainColor,
                  ),
                ),
              ),
              if ((widget.ad.rate?.toString().isNotEmpty ??
                      false) &&
                  widget.ad.rate.toString() != '-')
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF8E6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: AppColors.yellowColor,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${widget.ad.rate}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SvgPicture.asset(
                AppImages.location,
                width: 14,
                height: 14,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  (widget.ad.location
                              ?.toString()
                              .trim()
                              .isNotEmpty ??
                          false)
                      ? widget.ad.location.toString()
                      : "لا يوجد",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff9AA0A6)),
                ),
              ),
              Text(
                widget.ad.createdAt ?? '',
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xffB0B5BB)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Stats strip.
          _StatsStrip(ad: widget.ad),
          const SizedBox(height: 14),
          // Description.
          if ((widget.ad.desc?.trim().isNotEmpty ??
                  false) ||
              (widget.ad.description?.trim().isNotEmpty ??
                  false)) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: const Color(0xFFF0F0F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr(LocaleKeys.desAboutProduct),
                    style: AppStyles.textStyle16W600Black,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (widget.ad.desc?.trim().isNotEmpty ??
                            false)
                        ? widget.ad.desc!
                        : widget.ad.description ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: Color(0xff1F2937),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          // Actions.
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _onEdit,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppColors.mainColor,
                  ),
                  label: Text(
                    context.tr(LocaleKeys.editAd),
                    style: const TextStyle(
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
                        vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BlocBuilder<AdvertisementsCubit,
                    AdvertisementsStates>(
                  builder: (context, state) {
                    final deleting =
                        state is DeleteAdLoadingState &&
                            state.adId == widget.ad.id;
                    return ElevatedButton.icon(
                      onPressed:
                          deleting ? null : _onDelete,
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
                        disabledBackgroundColor: AppColors
                            .redColor
                            .withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12),
                        elevation: 0,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({required this.ad});

  final Ads ad;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _Stat(
          Icons.star_rounded,
          const Color(0xffFFF4D6),
          ad.rate?.toString() ?? '-',
          "التقييم"),
      _Stat(
          Icons.chat_bubble_outline_rounded,
          const Color(0xffE3F2FD),
          ad.countCommenets?.toString() ?? '-',
          "التعليقات"),
      _Stat(
          Icons.remove_red_eye_outlined,
          const Color(0xffE6F4EF),
          ad.reviewsCount?.toString() ?? '-',
          "المراجعات"),
    ];
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAF9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (int i = 0; i < stats.length; i++) ...[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: stats[i].tint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      stats[i].icon,
                      size: 16,
                      color: const Color(0xff1F2937),
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
                height: 36,
                color: const Color(0xFFE5E7EB),
              ),
          ],
        ],
      ),
    );
  }
}

class _Stat {
  final IconData icon;
  final Color tint;
  final String value;
  final String label;

  const _Stat(this.icon, this.tint, this.value, this.label);
}
