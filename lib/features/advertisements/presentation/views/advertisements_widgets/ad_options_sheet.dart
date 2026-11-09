import 'package:by3ly/core/shared_widgets/app_confirm_dialog.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addAdvertisements/presentation/views/edit_ad_view.dart';
import 'package:by3ly/features/advertisements/data/models/my_ads_data_model.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_cubit.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:by3ly/core/extensions/lang.dart';
import 'package:page_transition/page_transition.dart';

/// Bottom sheet with the seller's options for one of their own ads:
/// edit, pause/resume and delete.
///
/// [ad] must have a non-null [Ads.id] when calling actions that hit the
/// API (guarded inside handlers).
Future<void> showAdOptionsSheet(BuildContext context, Ads ad) async {
  final isActive = ad.isPaused != true;
  await showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
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
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 8),
            _OptionTile(
              icon: Icons.edit_outlined,
              title: context.tr(LocaleKeys.editAdAction),
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
                  AdvertisementsCubit.get(context).fetchMyAds();
                }
              },
            ),
            _OptionTile(
              icon: isActive
                  ? Icons.pause_circle_outline_rounded
                  : Icons.play_circle_outline_rounded,
              title: context.tr(
                isActive ? LocaleKeys.pauseAd : LocaleKeys.resumeAd,
              ),
              color: isActive
                  ? const Color(0xffF59E0B)
                  : const Color(0xff34C759),
              onTap: () async {
                Navigator.pop(sheetContext);
                if (ad.id == null) return;
                final pause = isActive;
                final title = context.tr(
                  pause ? LocaleKeys.pauseAd : LocaleKeys.resumeAd,
                );
                final confirmed = await AppConfirmDialog.show(
                  context,
                  title: title,
                  message: context.tr(
                    pause
                        ? LocaleKeys.pauseAdConfirm
                        : LocaleKeys.resumeAdConfirm,
                  ),
                  confirmText: title,
                  icon: pause
                      ? Icons.pause_circle_outline_rounded
                      : Icons.play_circle_outline_rounded,
                  accentColor: pause
                      ? AppColors.mainColor
                      : const Color(0xff34C759),
                );
                if (confirmed && context.mounted) {
                  final cubit = AdvertisementsCubit.get(context);
                  if (pause) {
                    await cubit.pauseAd(adId: ad.id!);
                  } else {
                    await cubit.resumeAd(adId: ad.id!);
                  }
                  // Status changed (e.g. paused → inactive): reload the
                  // list so the badge/status comes straight from the
                  // server instead of the cached value.
                  final state = cubit.state;
                  if (!cubit.isClosed &&
                      state is PauseResumeAdSuccessState &&
                      state.adId == ad.id) {
                    cubit.fetchMyAds();
                  }
                }
              },
            ),
            _OptionTile(
              icon: Icons.delete_outline_rounded,
              title: context.tr(LocaleKeys.deleteAd),
              danger: true,
              onTap: () async {
                Navigator.pop(sheetContext);
                if (ad.id == null) return;
                final confirmed = await AppConfirmDialog.show(
                  context,
                  title: context.tr(LocaleKeys.deleteAd),
                  message: context.tr(LocaleKeys.deleteAdConfirm),
                  confirmText: context.tr(LocaleKeys.deleteAd),
                  icon: Icons.delete_outline_rounded,
                );
                if (confirmed && context.mounted) {
                  AdvertisementsCubit.get(context).deleteAd(adId: ad.id!);
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}

/// One row of a bottom-sheet option (icon in a tinted square + label + arrow).
class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.danger = false,
    this.color,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool danger;

  /// Overrides the default accent colour (used by pause/resume).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolvedColor =
        color ?? (danger ? AppColors.redColor : AppColors.mainColor);
    final isRtl = context.isArabic;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: resolvedColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: resolvedColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ),
            Icon(
              isRtl
                  ? Icons.arrow_back_ios_rounded
                  : Icons.arrow_forward_ios_rounded,
              size: 15,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
