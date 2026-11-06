import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:by3ly/features/chat/presentation/view_model/chat_states.dart';
import 'package:by3ly/features/chat/presentation/view_model/chat_unread_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_states.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/shared_widgets/profile_info_shimmer.dart';
import '../../../chooseLocation/presentation/views/choose_location_view.dart';
import 'home_widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(AppImages.healthiconsMarket),
            Gap(10.w),
            Expanded(
              child: Text(
                context.tr(LocaleKeys.appName),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.yellowColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          BlocBuilder<ChatUnreadCubit, ChatUnreadStates>(
            builder: (context, state) {
              final unread = ChatUnreadCubit.get(context).count;

              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () async {
                    if (!await GuestGuard.requireLogin(context)) return;
                    if (!context.mounted) return;

                    context.pushNamed(Routes.conversationsView);
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.chat_rounded,
                          size: 21,
                          color: AppColors.yellowColor,
                        ),

                        if (unread > 0)
                          PositionedDirectional(
                            top: 0,
                            end: 0,
                            child: Container(
                              width: unread > 9 ? 20 : 11,
                              height: unread > 9 ? 20 : 11,
                              padding: unread > 9
                                  ? const EdgeInsets.all(2)
                                  : EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: AppColors.redColor,
                                shape: unread > 9
                                    ? BoxShape.rectangle
                                    : BoxShape.circle,
                                borderRadius: unread > 9
                                    ? BorderRadius.circular(10)
                                    : null,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: unread > 9
                                  ? Text(
                                unread > 99 ? '99+' : '$unread',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                                  : null,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          BlocBuilder<ProfileCubit, ProfileStates>(
            builder: (context, state) {
              final profileCubit = context.read<ProfileCubit>();
              final cityName =
                  profileCubit.profileModel?.data?.user?.cityName ?? '';
              if (state is GetProfileDataLoadingState) {
                return Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: const ProfileInfoShimmer(),
                );
              }

              if (state is GetProfileDataErrorState) {
                return Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Text(
                    state.error.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: InkWell(
                  // Choosing a delivery location is saved on the account:
                  // don't open it for guests.
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppImages.location,
                        colorFilter: const ColorFilter.mode(
                          AppColors.yellowColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      Gap(6.w),
                      Text(
                        context.tr(LocaleKeys.deliveryTo),
                        style: const TextStyle(
                          color: AppColors.yellowColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          cityName.isNotEmpty ? cityName : "No City",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: const HomeViewBody(),
    );
  }
}
