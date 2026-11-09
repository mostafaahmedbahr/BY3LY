import 'package:by3ly/core/utils/app_nav/new_app_nav.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../layout/presentation/views/layout_view.dart';
import '../../view_model/choose_location_cubit.dart';
import '../../view_model/choose_location_states.dart';
import 'choose_center.dart';
import 'choose_government.dart';
import 'choose_location_button.dart';

/// Body of the "choose your location" screen.
///
/// Brand header (logo) → headline/step guidelines → city list → center
/// list (revealed after a city is chosen) → confirm button.
class ChooseLocationViewBody extends StatelessWidget {
  const ChooseLocationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChooseLocationCubit, ChooseLocationStates>(
      listener: (context, state) {
        if (state is AddLocationCitiesAndCentersSuccess &&
            state.chooseLocationModel.status == false) {
          CherryToast.success(
            title: Text(
              state.chooseLocationModel.message!,
              style: const TextStyle(color: Colors.black),
            ),
          ).show(context);
          context.read<ProfileCubit>().getProfile();
          return;
        }
        if (state is AddLocationCitiesAndCentersSuccess) {
          CherryToast.success(
            title: Text(
              state.chooseLocationModel.message!,
              style: const TextStyle(color: Colors.black),
            ),
          ).show(context);
          NewAppNav.customNavigator(
            context: context,
            screen: const LayoutView(),
            finish: true,
          );
          context.read<ProfileCubit>().getProfile();
          return;
        }
        if (state is AddLocationCitiesAndCentersError) {
          CherryToast.error(
            title: Text(
              state.message,
              style: const TextStyle(color: Colors.black),
            ),
          ).show(context);
        }
      },
      builder: (context, state) {
        final cubit = ChooseLocationCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            top: false,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const BrandLogoHeader(),
                    const SizedBox(height: 16),
                    Text(
                      context.tr(LocaleKeys.selectYourGeographicLocation),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tr(
                        LocaleKeys.selectYourGovernorateFromTheFollowingList,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const ChooseGovernment(),
                    if (cubit.countryIsSelect) const ChooseCenter(),
                    const ChooseLocationButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
/// Brand logo header — white logo inside a soft gradient container with a
/// small glow so it reads as part of a premium onboarding-like screen.
class BrandLogoHeader extends StatelessWidget {
  const BrandLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mainColor,
            AppColors.secondColor,
            AppColors.buttonColor,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withValues(alpha: 0.4),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          AppImages.logo2,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
