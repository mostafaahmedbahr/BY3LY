import 'package:by3ly/features/register/presentation/view_model/register_cubit.dart';
import 'package:by3ly/features/register/presentation/view_model/register_states.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    var registerCubit = RegisterCubit.get(context);
    return Column(
      children: [
        /// phone number
        CustomTextFormField(
          maxLength: 11,
          controller: registerCubit.mobileCon,
          keyboardType: TextInputType.number,
          validator: (String? value) {
            return MyValidators.phoneValidator(value);
          },
          hintText: context.tr(LocaleKeys.writeYourPhoneNumberHere),
          prefixIcon: SvgPicture.asset(AppImages.egyptLogo),
        ),
        Gap(6.h),

        /// name
        CustomTextFormField(
          controller: registerCubit.nameCon,
          keyboardType: TextInputType.name,
          validator: (String? value) {
            return MyValidators.displayNameValidator(value);
          },
          hintText: context.tr(LocaleKeys.name),
          prefixIcon: SvgPicture.asset(AppImages.person),
        ),
        Gap(20.h),

        /// email
        CustomTextFormField(
          controller: registerCubit.emailCon,
          keyboardType: TextInputType.emailAddress,
          validator: (String? value) {
            return MyValidators.emailValidator(value);
          },
          hintText: context.tr(LocaleKeys.email),
          prefixIcon: SvgPicture.asset(AppImages.email),
        ),
        Gap(20.h),
        /// age
        CustomTextFormField(
          controller: registerCubit.ageCon,
          keyboardType: TextInputType.number,
          validator: (dynamic value) {
            return MyValidators.ageValidator(value);
          },
          hintText: context.tr(LocaleKeys.ageInvalid),
          prefixIcon: SvgPicture.asset(AppImages.email),
        ),
        Gap(20.h),
        BlocBuilder<RegisterCubit,RegisterStates>(
          buildWhen: (previous, current){
            return current is ChangeSuffixIconState
                || current is ChangeSuffixIconState2;
          },
          builder: (context,state){
            return  Column(
              children: [
                /// password
                CustomTextFormField(
                  controller: registerCubit.passCon,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (String? value) {
                    return MyValidators.passwordValidator(value);
                  },
                  suffixIcon: IconButton(
                    color: AppColors.greyColor,
                    icon: registerCubit.isVisible
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      registerCubit.changeSuffixIcon();
                    },
                  ),
                  hintText: context.tr(LocaleKeys.password),
                  prefixIcon: SvgPicture.asset(AppImages.lock),
                  obscureText: registerCubit.isVisible,
                ),
                Gap(20.h),

                /// validate password
                CustomTextFormField(
                  controller: registerCubit.confirmPassCon,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (String? value) {
                    return MyValidators.repeatPasswordValidator(
                      value: value,
                      password: registerCubit.passCon.text,
                    );
                  },
                  suffixIcon: IconButton(
                    color: AppColors.greyColor,
                    icon: registerCubit.isVisible2
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      registerCubit.changeSuffixIcon2();
                    },
                  ),
                  hintText: context.tr(LocaleKeys.confirmPassword),
                  prefixIcon: SvgPicture.asset(AppImages.lock),
                  obscureText: registerCubit.isVisible2,
                ),
              ],
            );
          },

        ),
      ],
    );
  }
}
