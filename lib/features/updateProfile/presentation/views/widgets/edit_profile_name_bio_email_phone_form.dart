


import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_cubit.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../main_importants.dart';
import '../../../../profile/presentation/view_model/profile_cubit.dart';

class EditProfileNameBioEmailPhoneForm extends StatefulWidget {
  const EditProfileNameBioEmailPhoneForm({super.key});

  @override
  State<EditProfileNameBioEmailPhoneForm> createState() => _EditProfileNameBioEmailPhoneFormState();
}

class _EditProfileNameBioEmailPhoneFormState extends State<EditProfileNameBioEmailPhoneForm> {
  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileCubit>().profileModel;
    if (profile != null) {
      context.read<UpdateProfileDataCubit>().initControllers(profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateProfileDataCubit,UpdateProfileDataStates>(
      builder: (context,state){
        var updateProfileDataCubit = UpdateProfileDataCubit.get(context);
        return Column(
          children: [
            const CustomSizedBox(height: 28,),
            CustomTextFormField(
              controller: updateProfileDataCubit.nameCon,
              keyboardType: TextInputType.text,
              hintText: LocaleKeys.name.tr(),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(AppImages.person,),
              ),
              validator: (String? value) {
                return MyValidators.displayNameValidator(value);
              },
            ),
            const CustomSizedBox(height: 20,),
            CustomTextFormField(
              controller: updateProfileDataCubit.emailCon,
              keyboardType: TextInputType.emailAddress,
              hintText: LocaleKeys.email.tr(),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(AppImages.email,),
              ),
              validator: (String? value) {
                return MyValidators.emailValidator(value);
              },
            ),
            const CustomSizedBox(height: 20,),
            CustomTextFormField(
              controller: updateProfileDataCubit.phoneCon,
              keyboardType: TextInputType.phone,
              hintText: LocaleKeys.phone.tr(),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(AppImages.phone,
                  colorFilter: const ColorFilter.mode(
                      AppColors.greyColor, BlendMode.srcIn),
                ),
              ),
              validator: (String? value) {
                return MyValidators.displayNameValidator(value);
              },
            ),
          ],
        );
      },

    );
  }
}
