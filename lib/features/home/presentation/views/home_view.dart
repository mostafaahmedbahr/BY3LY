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
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(AppImages.healthiconsMarket),
            Gap(10.w),
            Text(
              context.tr(LocaleKeys.appName),
              style: const TextStyle(
                color: AppColors.yellowColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
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
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: const ChooseLocationView(),
                      ),
                    );
                  },
                  child: Row(
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
                      Text(
                        cityName.isNotEmpty ? cityName : "No City",
                        style: const TextStyle(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
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

