import 'package:by3ly/core/shared_widgets/app_confirm_dialog.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addAdvertisements/presentation/views/edit_ad_view.dart';
import 'package:by3ly/features/advertisements/data/models/my_ads_data_model.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_cubit.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

/// Red full-width delete button with spinner while the request is in flight.
class AdDeleteButton extends StatelessWidget {
  const AdDeleteButton({super.key, required this.ad});

  final Ads ad;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementsCubit, AdvertisementsStates>(
      builder: (context, state) {
        final deleting =
            state is DeleteAdLoadingState && state.adId == ad.id;
        return ElevatedButton.icon(
          onPressed: deleting
              ? null
              : () async {
                  if (ad.id == null) return;
                  final confirmed = await AppConfirmDialog.show(
                    context,
                    title: context.tr(LocaleKeys.deleteAd),
                    message: context.tr(LocaleKeys.deleteAdConfirm),
                    confirmText: context.tr(LocaleKeys.deleteAd),
                    icon: Icons.delete_outline_rounded,
                  );
                  if (confirmed && context.mounted) {
                    AdvertisementsCubit.get(context)
                        .deleteAd(adId: ad.id!);
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
            disabledBackgroundColor:
                AppColors.redColor.withValues(alpha: 0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 11),
            elevation: 0,
          ),
        );
      },
    );
  }
}

/// Outlined green "options" button (settings icon) — opens the options sheet.
class AdOptionsButton extends StatelessWidget {
  const AdOptionsButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(
        Icons.settings_outlined,
        size: 18,
        color: AppColors.mainColor,
      ),
      label: Text(
        context.tr(LocaleKeys.optionsLabel),
        style: const TextStyle(
          color: AppColors.mainColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.mainColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 11),
      ),
    );
  }
}

/// Outlined green "edit" button — pushes EditAdView.
class AdEditButton extends StatelessWidget {
  const AdEditButton({super.key, required this.ad});

  final Ads ad;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
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
        side: const BorderSide(color: AppColors.mainColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
