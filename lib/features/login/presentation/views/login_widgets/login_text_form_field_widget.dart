import 'package:by3ly/features/login/presentation/view_model/login_cubit.dart';
import 'package:by3ly/features/login/presentation/view_model/login_states.dart';
 import 'package:easy_localization/easy_localization.dart';
 import '../../../../../main_importants.dart';

class LoginTextFormFieldWidget extends StatelessWidget {
  const LoginTextFormFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit,LoginStates>(
      buildWhen: (previous, current){
        return current is ChangePasswordVisibleState ||
            current is LoginLoadingState ||
            current is LoginErrorState
        ;
      },
      builder: (context,state){
        return IgnorePointer(
            ignoring : state is LoginLoadingState,
          child: Column(
            children: [
              // CustomTextFormField(
              //   controller:  context.read<LoginCubit>().emailCon,
              //   keyboardType: TextInputType.emailAddress,
              //   validator: (String? value) {
              //     return MyValidators.emailValidator(value);
              //   },
              //   hintText:   context.tr(LocaleKeys.email),
              //   prefixIcon: SvgPicture.asset(AppImages.email),
              // ),
              CustomTextFormField(
                maxLength: 11,
                controller:  context.read<LoginCubit>().phoneCon,
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  return MyValidators.phoneValidator(value);
                },
                hintText:   context.tr(LocaleKeys.writeYourPhoneNumberHere),
                prefixIcon: Padding(
                  padding:   EdgeInsets.all(8.0.r),
                  child: SvgPicture.asset(AppImages.egyptLogo),
                ),
              ),
              Gap(20.h),
              CustomTextFormField(
                controller:  context.read<LoginCubit>().passwordCon,
                keyboardType: TextInputType.visiblePassword,
                // validator: (String? value) {
                //   return MyValidators.passwordValidator(value);
                // },
                suffixIcon: IconButton(
                  color: AppColors.greyColor,
                  icon: context.read<LoginCubit>().isPasswordVisible
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onPressed: () {
                    context.read<LoginCubit>().changePasswordVisible();
                  },
                ),
                hintText: context.tr(LocaleKeys.password),
                prefixIcon: SvgPicture.asset(AppImages.lock),
                obscureText: context.read<LoginCubit>().isPasswordVisible,
              ),

            ],
          ),
        );
      },

    );
  }
}
