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
              return IconButton(
                tooltip: context.tr(LocaleKeys.conversations),
                onPressed: () async {
                  if (!await GuestGuard.requireLogin(context)) return;
                  if (!context.mounted) return;
                  context.pushNamed(Routes.conversationsView);
                },
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.yellowColor,
                    ),
                    if (unread > 0)
                      PositionedDirectional(
                        top: -5,
                        end: -5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          constraints: const BoxConstraints(minWidth: 16),
                          decoration: BoxDecoration(
                            color: AppColors.redColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unread > 99 ? '99+' : '$unread',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
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
