import 'package:by3ly/core/shared_cubits/auth_cubit/auth_cubit.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/core/utils/app_consts/storage_keys.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/login_cubit.dart';
import '../../view_model/login_states.dart';

/// Premium CTA stack: red gradient primary login button, outlined register,
/// an "or" divider and a text-link guest entry.
class LoginButtonsWidget extends StatelessWidget {
  const LoginButtonsWidget({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          // Real login ends any previous guest mode.
          final token = state.loginModel.data?.user?.token?.toString() ?? '';
          context.read<AuthCubit>().loginWithToken(token);
          // Fetch fresh profile from the start (clears any previous user data).
          try {
            context.read<ProfileCubit>().getProfile();
          } catch (_) {}
          context.pushNamedAndRemoveAll(Routes.layoutView);
          Toast.showSuccessToast(
              msg: state.loginModel.message?.trim().isNotEmpty == true
                  ? state.loginModel.message!
                  : context.tr(LocaleKeys.loginSuccess),
              context: context);
        } else if (state is LoginSuccessWithNoActiveState) {
          context.pushNamed(Routes.otpView,
              arguments: CacheHelper.getData(key: "email"));
          final codeSuffix = state.code == null
              ? ''
              : ' ${LocaleKeys.code.tr()} : ${state.code}';
          Toast.showSuccessToast(
              duration: const Duration(seconds: 10),
              msg: '${LocaleKeys.theActivationCodeHasBeenSentToYourEmailAddress.tr()}$codeSuffix',
              context: context);
        } else if (state is LoginErrorState) {
          Toast.showErrorToast(msg: state.error, context: context);
        }
      },
      builder: (context, state) {
        final loginCubit = context.read<LoginCubit>();
        final busy = state is LoginLoadingState;

        return IgnorePointer(
          ignoring: busy,
          child: Column(
            children: [
              ConditionalBuilder(
                condition: !busy,
                fallback: (context) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: CustomLoading(),
                ),
                builder: (context) {
                  return _PrimaryCta(
                    label: context.tr(LocaleKeys.login),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        loginCubit.login(
                          phone: loginCubit.phoneCon.text,
                          password: loginCubit.passwordCon.text,
                          deviceToken: CacheHelper.getData(
                                key: StorageKeys.fcmToken,
                              ) ??
                              '',
                        );
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              _GhostCta(
                label: context.tr(LocaleKeys.register),
                onPressed: () => context.pushNamed(Routes.registerView),
              ),
              const SizedBox(height: 14),
              // "or" divider between the two CTAs blocks.
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.border, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      context.tr(LocaleKeys.or),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.border, thickness: 1)),
                ],
              ),
              const SizedBox(height: 10),
              // Guest entry — text-link with a chevron.
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => GuestGuard.enterAsGuest(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.tr(LocaleKeys.continueAsGuest),
                        style: TextStyle(
                          color: AppColors.mainColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: AppColors.mainColor,
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

/// Primary red gradient CTA — the strongest interactive element on the page.
class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
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
              color: AppColors.mainColor.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(14),
            child: Center(
              child: Text(
                label,
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
  }
}

/// Secondary outlined CTA used for the register action.
class _GhostCta extends StatelessWidget {
  const _GhostCta({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.mainColor,
          side: const BorderSide(color: AppColors.mainColor, width: 1.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.mainColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
