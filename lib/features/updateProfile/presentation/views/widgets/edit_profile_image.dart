

import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_cubit.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../main_importants.dart';
import '../../../../profile/presentation/view_model/profile_cubit.dart';

class EditProfileImage extends StatelessWidget {
  const EditProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateProfileDataCubit, UpdateProfileDataStates>(
      builder: (context, state) {
        var updateProfileDataCubit = UpdateProfileDataCubit.get(context);
        String? imageUrl = context.read<ProfileCubit>().profileModel!.data!.user!.image;

        return Row(
          children: [
            GestureDetector(
              onTap: updateProfileDataCubit.uploadProfilePicture,
              child: Container(
                height: 84,
                width: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.whiteColor,
                  image: updateProfileDataCubit.profileImage != null
                      ? DecorationImage(
                    image: FileImage(updateProfileDataCubit.profileImage!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: updateProfileDataCubit.profileImage != null
                    ? null
                    : imageUrl != null && imageUrl.isNotEmpty
                    ? ClipOval(
                  child: CustomNetWorkImage(
                    fit: BoxFit.cover,
                    height: 84,
                    width: 84,
                    imageUrl: imageUrl,
                    raduis: 50,
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SvgPicture.asset(AppImages.camera),
                ),
              ),
            ),
            const CustomSizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
               LocaleKeys.profilePhoto.tr(),
                  style: AppStyles.textStyle16W500Black,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: updateProfileDataCubit.uploadProfilePicture,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.mainColor,
                      ),
                      child: Text(
                          LocaleKeys.change.tr(),
                        style: AppStyles.textStyle16W500Black,
                      ),
                    ),
                    if (updateProfileDataCubit.profileImage != null)
                      TextButton(
                        onPressed: updateProfileDataCubit.clearProfileImage,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.mainColor,
                        ),
                        child:  Text(
                           LocaleKeys.delete.tr(),
                          style: AppStyles.textStyle16W500Black.copyWith(
                            color: AppColors.redColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
