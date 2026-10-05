import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_services/local_services/cache_helper.dart';
import '../extensions/navigate.dart';
import '../routing/routes.dart';
import '../shared_cubits/auth_cubit/auth_cubit.dart';
import '../shared_widgets/app_confirm_dialog.dart';
import '../shared_widgets/custom_button.dart';
import 'app_colors/app_colors.dart';
import '../../features/layout/presentation/view_model/layout_cubit.dart';
import '../../lang/locale_keys.dart';

/// Guest-mode helpers: users without an account can browse the app,
/// anything that needs a token asks them to log in first.
class GuestGuard {
  const GuestGuard._();

  /// True when the app is running in guest (visitor) mode.
  static bool get isGuest =>
      CacheHelper.getData(key: 'isGuest') == true;

  /// Enter guest mode and go to the home layout.
  static void enterAsGuest(BuildContext context) {
    context.read<AuthCubit>().loginAsGuest();
    context.pushNamedAndRemoveAll(Routes.layoutView);
  }

  /// Leave guest mode and go back to the login screen.
  static void exitToLogin(BuildContext context) {
    context.read<AuthCubit>().logout();
    LayoutCubit.pageIndex = 0;
    context.pushNamedAndRemoveAll(Routes.loginView);
  }

  /// Returns true when the action may continue.
  /// For guests it shows a "login required" dialog and returns false.
  static Future<bool> requireLogin(BuildContext context) async {
    if (!isGuest) return true;
    final goLogin = await AppConfirmDialog.show(
      context,
      title: context.tr(LocaleKeys.loginRequiredTitle),
      message: context.tr(LocaleKeys.loginRequiredMessage),
      confirmText: context.tr(LocaleKeys.login),
      icon: Icons.person_outline_rounded,
      accentColor: AppColors.mainColor,
    );
    if (goLogin && context.mounted) exitToLogin(context);
    return false;
  }
}

/// Full-screen placeholder shown to guests instead of account-only tabs
/// (profile / notifications) with a button to go log in.
class GuestPlaceholder extends StatelessWidget {
  const GuestPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 88,
              width: 88,
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                size: 44,
                color: AppColors.mainColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.tr(LocaleKeys.guestModeTitle),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xff1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr(LocaleKeys.guestModeMessage),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.6,
                color: Color(0xff9AA0A6),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              btnText: Text(
                context.tr(LocaleKeys.login),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onPressed: () => GuestGuard.exitToLogin(context),
            ),
          ],
        ),
      ),
    );
  }
}
