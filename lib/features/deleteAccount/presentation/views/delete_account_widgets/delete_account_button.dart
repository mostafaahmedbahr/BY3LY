import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/app_confirm_dialog.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/delete_account_cubit.dart';
import '../../view_model/delete_account_states.dart';

/// Full-width red CTA. Tapping asks for an explicit confirmation first
/// (destructive, irreversible after 90 days), shows a spinner while the
/// request is in flight, clears the local session on success and routes
/// to the login screen.
class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({super.key});

  Future<void> _confirmAndDelete(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.tr(LocaleKeys.deleteAccount),
      message: context.tr(LocaleKeys.deleteAccountConfirmMessage),
      confirmText: context.tr(LocaleKeys.deleteNow),
      icon: Icons.delete_forever_rounded,
    );
    if (confirmed && context.mounted) {
      DeleteAccountCubit.get(context).deleteAccount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteAccountCubit, DeleteAccountStates>(
      listener: (context, state) {
        if (state is DeleteAccountSuccess) {
          DeleteAccountCubit.get(context).clearSession();
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.loginView,
            (route) => false,
          );
          CherryToast.success(
            title: Text(
              state.deleteAccountModel.message ??
                  context.tr(LocaleKeys.deleteAccount),
              style: const TextStyle(color: AppColors.mainColor),
            ),
          ).show(context);
        } else if (state is DeleteAccountError) {
          CherryToast.error(
            title: Text(
              state.message ?? context.tr(LocaleKeys.deleteAccountFailed),
              style: const TextStyle(color: AppColors.redColor),
            ),
          ).show(context);
        }
      },
      builder: (context, state) {
        final submitting = state is DeleteAccountLoading;
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  submitting
                      ? AppColors.redColor.withValues(alpha: 0.55)
                      : AppColors.redColor,
                  const Color(0xffB91C1C),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: submitting
                  ? const []
                  : [
                      BoxShadow(
                        color: AppColors.redColor.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: submitting ? null : () => _confirmAndDelete(context),
                borderRadius: BorderRadius.circular(14),
                child: Center(
                  child: submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              context.tr(LocaleKeys.deleteNow),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
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
