import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/core/shared_widgets/profile_info_shimmer.dart';
import 'package:by3ly/features/chooseLocation/presentation/views/choose_location_view.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_states.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';

/// Premium home app bar: marketplace logo, location pill and
/// the notifications bell with an unread badge.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(70.h);

  @override
  Widget build(BuildContext context) {
    return
AppBar(
        toolbarHeight: 70.h,
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: 16.w,

        // Chic & clean — soft bottom divider
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(
                color: AppColors.border.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
          ),
        ),

        title: Row(
          children: [
            Container(
              width: 34.w,
              height: 34.h,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppImages.healthiconsMarket,
                width: 22.w,
                height: 22.h,
              ),
            ),
            Gap(12.w),
            Flexible(
              child: Text(
                context.tr(LocaleKeys.appName),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),

        actions: [
          // Location chip — chic pill
          BlocBuilder<ProfileCubit, ProfileStates>(
            builder: (context, state) {
              final profileCubit = context.read<ProfileCubit>();
              final cityName =
                  profileCubit.profileModel?.data?.user?.cityName ?? '';

              if (state is GetProfileDataLoadingState) {
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: 14.w),
                  child: const ProfileInfoShimmer(),
                );
              }

              if (state is GetProfileDataErrorState) {
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: 14.w),
                  child: const Icon(
                    Icons.location_off_outlined,
                    color: AppColors.redColor,
                  ),
                );
              }

              return Padding(
                padding: EdgeInsetsDirectional.only(end: 14.w),
                child: Material(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(18.r),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18.r),
                    onTap: () async {
                      if (!await GuestGuard.requireLogin(context)) return;
                      if (!context.mounted) return;

                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: const ChooseLocationView(),
                        ),
                      );
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 150.w,
                        minHeight: 42.h,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 30.w,
                              height: 30.h,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: AppColors.border.withValues(
                                    alpha: 0.25,
                                  ),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                AppImages.location,
                                width: 16.w,
                                height: 16.h,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.yellowColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),

                            Gap(8.w),

                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    context.tr(LocaleKeys.deliveryTo),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 1.0,
                                    ),
                                  ),

                                  Text(
                                    cityName.isNotEmpty
                                        ? cityName
                                        : "No City",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 11.5.sp,
                                      fontWeight: FontWeight.w800,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Gap(2.w),

                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 16.sp,
                              color: AppColors.accent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Notifications button — chic circle

          BlocBuilder<NotificationsCubit, NotificationsStates>(
            builder: (context, state) {
              final unread = NotificationsCubit.get(context).unreadCount;

              return Padding(
                padding: EdgeInsetsDirectional.only(end: 12.w),
                child: Center(
                  child: Material(
                    color: AppColors.surfaceVariant,
                    shape: const CircleBorder(),
                    elevation: 2,
                    shadowColor: AppColors.accent.withValues(alpha: 0.10),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      splashColor: AppColors.accent.withValues(alpha: 0.08),
                      highlightColor: AppColors.accent.withValues(alpha: 0.04),
                      onTap: () async {
                        if (!await GuestGuard.requireLogin(context)) return;
                        if (!context.mounted) return;

                        context.pushNamed(Routes.notificationsView);
                      },
                      child: SizedBox(
                        width: 46.w,
                        height: 46.w,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              size: 24.sp,
                              color: AppColors.accent,
                            ),

                            if (unread > 0)
                              PositionedDirectional(
                                top: 5,
                                end: 5,
                                child: Container(
                                  constraints: BoxConstraints(
                                    minWidth: 17.w,
                                    minHeight: 17.w,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.redColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.surfaceVariant,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.redColor.withValues(alpha: 0.20),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    unread > 99 ? '99+' : '$unread',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

        ],
      );
  }
}
