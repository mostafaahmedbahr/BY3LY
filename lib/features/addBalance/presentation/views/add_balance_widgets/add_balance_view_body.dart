import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../confirmPayment/presentation/views/confirm_payment_view.dart';
import 'instapay_tile.dart';
import 'vodafone_cash_tile.dart';

class AddBalanceViewBody extends StatelessWidget {
  const AddBalanceViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VodafoneCashTile(),
          const SizedBox(height: 12),
          const InstapayTile(),
          const Spacer(),
          const SizedBox(height: 16),
          CustomButton(
            btnText: Text(
              LocaleKeys.confirmPayment.tr(),
              style:
                  AppStyles.textStyle16W600Black.copyWith(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const ConfirmPaymentView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
