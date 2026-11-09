import 'package:flutter/material.dart';

import 'package:by3ly/core/utils/app_colors/app_colors.dart';

import 'change_password_button.dart';
import 'change_password_form.dart';
import 'premium_hero_header.dart';

class ChangePasswordViewBody extends StatelessWidget {
  const ChangePasswordViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.surfaceVariant.withValues(alpha: 0.55),
              AppColors.background,
            ],
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: PremiumHeroHeader(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: Form(
                  key: formKey,
                  child: const ChangePasswordForm(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                0,
                20,
                12 + MediaQuery.of(context).padding.bottom,
              ),
              child: ChangePasswordButton(formKey: formKey),
            ),
          ],
        ),
      ),
    );
  }
}
