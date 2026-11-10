import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/features/register/presentation/view_model/register_cubit.dart';
import 'package:by3ly/features/register/presentation/view_model/register_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Primary CTA — identical look and interaction model as the login button
/// (gradient main → second color, glow shadow, full-width radius-14).
class RegisterButtons extends StatelessWidget {
  const RegisterButtons({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      buildWhen: (previous, current) {
        return current is ClearDataSuccess ||
            current is SignUpLoading ||
            current is SignUpSuccess ||
            current is SignUpError;
      },
      listener: (context, state) {
        if (state is SignUpSuccess) {
          final otp = state.registerModel.data?.activationCode;
          final email = state.registerModel.data?.resolvedEmail ?? "";
          final baseMsg = state.registerModel.message ?? "";
          Toast.showSuccessToast(
              duration: const Duration(seconds: 10),
              msg: otp != null && otp.isNotEmpty
                  ? "$baseMsg\nOTP : $otp"
                  : baseMsg,
              context: context);
          // Close the keyboard BEFORE navigating so the focus manager
          // doesn't try to highlight widgets that are about to deactivate.
          FocusScope.of(context).unfocus();
          context.pushNamed(
            Routes.otpView,
            arguments: email,
          );
          context.read<RegisterCubit>().clearData();
        } else if (state is SignUpError) {
          Toast.showErrorToast(msg: state.message, context: context);
        }
      },
      builder: (context, state) {
        final busy = state is SignUpLoading;

        return IgnorePointer(
          ignoring: busy,
          child: Column(
            children: [
              if (busy)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: CustomLoading(),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.mainColor,
                          AppColors.secondColor,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppColors.mainColor.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          final form = formKey.currentState;
                          if (form != null && form.validate()) {
                            var registerCubit = RegisterCubit.get(context);
                            registerCubit.signUp(
                              name: registerCubit.nameCon.text,
                              password: registerCubit.passCon.text,
                              email: registerCubit.emailCon.text,
                              age: registerCubit.ageCon.text,
                              phoneNumber: registerCubit.mobileCon.text,
                              image: registerCubit.profileImage,
                            );
                          }
                        },
                        child: Center(
                          child: Text(
                            context.tr(LocaleKeys.register2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
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
