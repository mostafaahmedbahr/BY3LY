import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_validator/app_validator.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/change_password_cubit.dart';
import '../../view_model/change_password_states.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordStates>(
      buildWhen: (previous, current) =>
          current is ChangeConfirmNewPasswordVisibleState ||
          current is ChangeNewPasswordVisibleState ||
          current is ChangeOldPasswordVisibleState,
      builder: (context, state) {
        final cubit = context.read<ChangePasswordCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: AppColors.mainColor.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionTitle(
                    icon: Icons.lock_outline_rounded,
                    label: context.tr(LocaleKeys.currentPassword),
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    onFieldSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(cubit.newPasswordFocusNode),
                    controller: cubit.oldPasswordCon,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: context.tr(LocaleKeys.currentPasswordHint),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.lock_outline_rounded,
                          color: AppColors.mainColor, size: 22),
                    ),
                    validator: (String? value) =>
                        MyValidators.passwordValidator(value),
                    suffixIcon: IconButton(
                      color: AppColors.textSecondary,
                      icon: cubit.isOldPasswordVisible
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: cubit.changeOldPasswordVisible,
                    ),
                    obscureText: cubit.isOldPasswordVisible,
                  ),
                  const SizedBox(height: 20),
                  _SectionTitle(
                    icon: Icons.vpn_key_outlined,
                    label: context.tr(LocaleKeys.newPassword),
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    onFieldSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(cubit.confirmNewPasswordFocusNode),
                    focusNode: cubit.newPasswordFocusNode,
                    controller: cubit.newPasswordCon,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: context.tr(LocaleKeys.newPassword),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.vpn_key_outlined,
                          color: AppColors.mainColor, size: 22),
                    ),
                    validator: (String? value) =>
                        MyValidators.passwordValidator(value),
                    suffixIcon: IconButton(
                      color: AppColors.textSecondary,
                      icon: cubit.isNewPasswordVisible
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: cubit.changeNewPasswordVisible,
                    ),
                    obscureText: cubit.isNewPasswordVisible,
                  ),
                  const SizedBox(height: 20),
                  _SectionTitle(
                    icon: Icons.shield_outlined,
                    label: context.tr(LocaleKeys.confirmPassword),
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    focusNode: cubit.confirmNewPasswordFocusNode,
                    controller: cubit.confirmNewPasswordCon,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: context.tr(LocaleKeys.confirmPassword),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.shield_outlined,
                          color: AppColors.mainColor, size: 22),
                    ),
                    validator: (String? value) =>
                        MyValidators.repeatPasswordValidator(
                      value: value,
                      password: cubit.newPasswordCon.text,
                    ),
                    suffixIcon: IconButton(
                      color: AppColors.textSecondary,
                      icon: cubit.isConfirmNewPasswordVisible
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: cubit.changeConfirmNewPasswordVisible,
                    ),
                    obscureText: cubit.isConfirmNewPasswordVisible,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "• ${context.tr(LocaleKeys.passwordRequirementsTitle)}",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.2,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.accent,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
