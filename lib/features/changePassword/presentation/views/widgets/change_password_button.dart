import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../layout/presentation/view_model/layout_cubit.dart';
import '../../view_model/change_password_cubit.dart';
import '../../view_model/change_password_states.dart';
import 'premium_cta_button.dart';

class ChangePasswordButton extends StatelessWidget {
  const ChangePasswordButton({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordStates>(
      buildWhen: (previous, current) =>
          current is ChangePasswordSuccessState ||
          current is ChangePasswordErrorState ||
          current is ChangePasswordLoadingState,
      listener: (context, state) {
        if (state is ChangePasswordSuccessState) {
          Toast.showSuccessToast(
            msg: state.changePasswordModel.message.toString(),
            context: context,
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.loginView,
            (route) => false,
          );
          context.read<ChangePasswordCubit>().clearUserData();
          context.read<LayoutCubit>().changeBottomNav(0, context);
        } else if (state is ChangePasswordErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.toString()),
              backgroundColor: AppColors.redColor,
            ),
          );
        }
      },
      builder: (context, state) {
        final submitting = state is ChangePasswordLoadingState;
        return SafeArea(
          top: false,
          child: PremiumCtaButton(
            submitting: submitting,
            onPressed: submitting ? () {} : () => _submit(context),
          ),
        );
      },
    );
  }

  void _submit(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      context.read<ChangePasswordCubit>().changePassword();
    }
  }
}
