import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/utils/app_consts/storage_keys.dart';
import 'package:by3ly/core/shared_cubits/auth_cubit/auth_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/otp_cubit.dart';
import '../../view_model/otp_states.dart';

/// Full-width gradient CTA for the confirm action — same brand as the
/// login screen (green gradient, bold white label) with a built-in loading
/// state.
class OtpButton extends StatelessWidget {
  const OtpButton({
    super.key,
    required this.formKey,
    required this.controller,
    required this.email,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit, OtpStates>(
      listener: (context, state) {
        if (state is VerifyOtpSuccessState) {
          // Sync AuthCubit so app treats user as logged-in (splash/guard logic).
          final token = state.otpModel.data?.resolvedToken ?? '';
          if (token.isNotEmpty && token != 'null') {
            context.read<AuthCubit>().loginWithToken(token);
          }
          // Fetch fresh profile right after activation.
          try {
            context.read<ProfileCubit>().getProfile();
          } catch (_) {}
          final msg = state.otpModel.message?.trim().isNotEmpty == true
              ? state.otpModel.message!
              : context.tr(LocaleKeys.loginSuccess);
          CherryToast.success(
            title: Text(msg, style: const TextStyle(color: AppColors.mainColor)),
          ).show(context);
          FocusScope.of(context).unfocus();
          context.pushNamedAndRemoveAll(Routes.chooseLocationView);
        } else if (state is VerifyOtpErrorState) {
          CherryToast.error(
            title: Text(
              state.error,
              style: const TextStyle(color: AppColors.redColor),
            ),
          ).show(context);
        }
      },
      builder: (context, state) {
        final verifying = state is VerifyOtpLoadingState;
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: verifying
                    ? [
                        AppColors.mainColor.withValues(alpha: 0.55),
                        AppColors.secondColor.withValues(alpha: 0.55),
                      ]
                    : const [
                        AppColors.mainColor,
                        AppColors.secondColor,
                      ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: verifying
                  ? const []
                  : [
                      BoxShadow(
                        color: AppColors.mainColor.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: verifying
                    ? null
                    : () {
                        if (formKey.currentState?.validate() ?? false) {
                          context.read<OtpCubit>().verifyOtp(
                                otp: controller.text,
                                email: email.isEmpty
                                    ? (CacheHelper.getData(key: 'email') ?? '')
                                    : email,
                                deviceToken:
                                    CacheHelper.getData(key: StorageKeys.fcmToken)
                                            as String? ??
                                        '',
                              );
                        }
                      },
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: verifying
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          context.tr(LocaleKeys.confirm),
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
        );
      },
    );
  }
}
