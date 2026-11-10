import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/core/utils/app_nav/new_app_nav.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_states.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../main_importants.dart';
import '../../../../updateProfile/presentation/views/update_profile_data_view.dart';
import '../../view_model/profile_cubit.dart';

class ProfileDataWidget extends StatelessWidget {
  const ProfileDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        var profileCubit = ProfileCubit.get(context);
        final user = profileCubit.profileModel?.data?.user;
        if (state is GetProfileDataLoadingState || user == null) {
          if (state is GetProfileDataErrorState) {
            return CustomErrorWidget(
              error: state.error,
              onTap: () => profileCubit.getProfile(),
            );
          }
          if (state is GetProfileDataSuccessState &&
              state.profileModel.status == false) {
            return CustomErrorWidget(
              error: state.profileModel.message ?? 'Server Error',
              onTap: () => profileCubit.getProfile(),
            );
          }
          return const SimmerLoading(height: 80);
        }
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.mainColor.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.surfaceVariant,
                      border: Border.all(color: AppColors.surfaceVariant),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: profileCubit.file != null &&
                              profileCubit.file!.path != ""
                          ? Image.file(
                              profileCubit.file!,
                              fit: BoxFit.cover,
                              height: 56,
                              width: 56,
                            )
                          : CustomNetWorkImage(
                              imageUrl: user.image ?? '',
                              raduis: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      profileCubit.uploadOnlyImage();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppColors.mainColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 11,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.textStyle16W600Black.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.phone ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.textStyle14W500Gray.copyWith(
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${context.tr(LocaleKeys.memberFrom)} ${user.createdAt ?? ''}",
                      style: AppStyles.textStyle10W400Gray.copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  NewAppNav.customNavigator(
                    context: context,
                    screen: const UpdateProfileDataView(),
                  );
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit_rounded,
                        size: 13,
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        context.tr(LocaleKeys.change),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
