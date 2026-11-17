import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/features/PaymentBalance/presentation/views/payment_and_balance_view.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

/// Legacy entry point. It no longer displays hardcoded transfer numbers:
/// deposits go through the server-verified wallet/top-up flow instead.
class AddBalanceViewBody extends StatelessWidget {
  const AddBalanceViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              context.tr(LocaleKeys.legacyTopUpNotice),
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Spacer(),
          CustomButton(
            btnText: Text(
              context.tr(LocaleKeys.openWalletTopUp),
              style: AppStyles.textStyle16W600Black.copyWith(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const PaymentAndBalanceView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
