import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_cubit.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_states.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Avatar editor — shows the picked image (or the current one from the
/// profile API) and exposes change/remove actions.
class EditProfileImage extends StatelessWidget {
  const EditProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateProfileDataCubit, UpdateProfileDataStates>(
      builder: (context, state) {
        final updateProfileDataCubit = UpdateProfileDataCubit.get(context);
        final imageUrl =
            context.read<ProfileCubit>().profileModel?.data?.user?.image;
        final picked = updateProfileDataCubit.profileImage;

        Widget avatarChild;
        if (picked != null) {
          avatarChild = ClipOval(
            child: Image.file(
              picked,
              fit: BoxFit.cover,
              width: 84,
              height: 84,
            ),
          );
        } else if (imageUrl != null && imageUrl.isNotEmpty) {
          avatarChild = ClipOval(
            child: CustomNetWorkImage(
              fit: BoxFit.cover,
              height: 84,
              width: 84,
              imageUrl: imageUrl,
              raduis: 50,
            ),
          );
        } else {
          avatarChild = Padding(
            padding: const EdgeInsets.all(20.0),
            child: SvgPicture.asset(
              AppImages.camera,
              colorFilter: ColorFilter.mode(
                AppColors.text,
                BlendMode.srcIn,
              ),
            ),
          );
        }

        return Row(
          children: [
            GestureDetector(
              onTap: updateProfileDataCubit.uploadProfilePicture,
              child: Container(
                height: 84,
                width: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceVariant,
                ),
                child: avatarChild,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  context.tr(LocaleKeys.profilePhoto),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: updateProfileDataCubit.uploadProfilePicture,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.mainColor,
                      ),
                      child: Text(
                        context.tr(LocaleKeys.change),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (picked != null)
                      TextButton(
                        onPressed: updateProfileDataCubit.clearProfileImage,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.mainColor,
                        ),
                        child: Text(
                          context.tr(LocaleKeys.delete),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.redColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          ],
        );
      },
    );
  }
}

