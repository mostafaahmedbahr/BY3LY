import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/core/utils/app_validator/app_validator.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_cubit.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_states.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Name / email / phone fields pre-filled from the profile cache.
class EditProfileNameBioEmailPhoneForm extends StatefulWidget {
  const EditProfileNameBioEmailPhoneForm({super.key});

  @override
  State<EditProfileNameBioEmailPhoneForm> createState() =>
      _EditProfileNameBioEmailPhoneFormState();
}

class _EditProfileNameBioEmailPhoneFormState
    extends State<EditProfileNameBioEmailPhoneForm> {
  @override
  void initState() {
    super.initState();
    // Pre-fill once — controllers must not re-render user edits away.
    final profile = context.read<ProfileCubit>().profileModel;
    if (profile != null) {
      context.read<UpdateProfileDataCubit>().initControllers(profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateProfileDataCubit, UpdateProfileDataStates>(
      builder: (context, state) {
        final updateProfileDataCubit = UpdateProfileDataCubit.get(context);
        return Column(
          children: [
            CustomTextFormField(
              controller: updateProfileDataCubit.nameCon,
              keyboardType: TextInputType.text,
              hintText: context.tr(LocaleKeys.name),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(AppImages.person),
              ),
              validator: MyValidators.displayNameValidator,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: updateProfileDataCubit.emailCon,
              keyboardType: TextInputType.emailAddress,
              hintText: context.tr(LocaleKeys.email),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(AppImages.email),
              ),
              validator: MyValidators.emailValidator,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: updateProfileDataCubit.phoneCon,
              keyboardType: TextInputType.phone,
              maxLength: 11,
              hintText: context.tr(LocaleKeys.phone),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  AppImages.phone,
                  colorFilter: ColorFilter.mode(
                    AppColors.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? null // phone is optional — only validate when filled
                      : MyValidators.phoneValidator(value),
            ),
          ],
        );
      },
    );
  }
}
