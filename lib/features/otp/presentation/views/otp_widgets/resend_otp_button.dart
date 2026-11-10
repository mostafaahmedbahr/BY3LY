import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/otp_cubit.dart';
import '../../view_model/otp_states.dart';

/// Premium resend footer: dim countdown text while waiting, gold pill
/// button once the cooldown elapses (loading state while a request flies).
class ResendOtpButton extends StatelessWidget {
  const ResendOtpButton({
    super.key,
    this.onPressed,
    this.showResend,
    this.secondsRemaining,
  });

  final VoidCallback? onPressed;
  final bool? showResend;
  final int? secondsRemaining;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit, OtpStates>(
      listener: (context, state) {
        if (state is ResendOtpSuccessState) {
          CherryToast.success(
            toastDuration: const Duration(seconds: 8),
            title: Text(
              '${state.resendOtpModel.message} ${state.resendOtpModel.data?.code ?? ''}'
                  .trim(),
              style: const TextStyle(color: AppColors.mainColor),
            ),
          ).show(context);
        } else if (state is ResendOtpErrorState) {
          CherryToast.error(
            title: Text(
              state.error,
              style: const TextStyle(color: AppColors.redColor),
            ),
          ).show(context);
        }
      },
      builder: (context, state) {
        final resending = state is ResendOtpLoadingState;
        final canResend = showResend == true;

        return Center(
          child: resending
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 34,
                    width: 34,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  ),
                )
              : canResend
                  ? TextButton.icon(
                      onPressed: onPressed,
                      icon: const Icon(
                        Icons.refresh_rounded,
                        size: 18,
                        color: AppColors.mainColor,
                      ),
                      label: Text(
                        context.tr(LocaleKeys.resendCode),
                        style: const TextStyle(
                          color: AppColors.mainColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.1,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 15,
                          color: AppColors.textSecondary.withValues(alpha: 0.85),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.tr(LocaleKeys.resendCodeIn).replaceAll(
                              '{seconds}',
                              '${(secondsRemaining ?? 0)}',
                            ),
                          style: TextStyle(
                            color: AppColors.textSecondary.withValues(alpha: 0.85),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }
}
