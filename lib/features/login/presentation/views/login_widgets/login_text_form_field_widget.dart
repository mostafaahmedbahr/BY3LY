import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/core/utils/app_validator/app_validator.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:by3ly/features/login/presentation/view_model/login_cubit.dart';
import 'package:by3ly/features/login/presentation/view_model/login_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Phone + password inputs, rendered inside the white card.
class LoginTextFormFieldWidget extends StatelessWidget {
  const LoginTextFormFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginStates>(
      buildWhen: (previous, current) {
        return current is ChangePasswordVisibleState ||
            current is LoginLoadingState ||
            current is LoginErrorState;
      },
      builder: (context, state) {
        final busy = state is LoginLoadingState;
        return IgnorePointer(
          ignoring: busy,
          child: Column(
            children: [
              CustomTextFormField(
                maxLength: 11,
                controller: context.read<LoginCubit>().phoneCon,
                keyboardType: TextInputType.number,
                validator: (String? value) =>
                    MyValidators.phoneValidator(value),
                hintText: context.tr(LocaleKeys.writeYourPhoneNumberHere),
                fillColor: AppColors.surfaceVariant,
                radius: 14,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: SvgPicture.asset(AppImages.egyptLogo),
                ),
              ),
              Gap(14.h),
              CustomTextFormField(
                controller: context.read<LoginCubit>().passwordCon,
                keyboardType: TextInputType.visiblePassword,
                fillColor: AppColors.surfaceVariant,
                radius: 14,
                hintText: context.tr(LocaleKeys.password),
                obscureText:
                    context.read<LoginCubit>().isPasswordVisible,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(AppImages.lock),
                ),
                suffixIcon: IconButton(
                  color: AppColors.textSecondary,
                  onPressed: () =>
                      context.read<LoginCubit>().changePasswordVisible(),
                  icon: Icon(
                    context.read<LoginCubit>().isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
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
