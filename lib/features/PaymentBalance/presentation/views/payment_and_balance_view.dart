import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/PaymentBalance/presentation/views/payment_balance_widgets/payment_and_balance_view_body.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PaymentAndBalanceView extends StatelessWidget {
  const PaymentAndBalanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title:   Text(LocaleKeys.paymentAndBalance.tr(),style: const TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: const PaymentAndBalanceViewBody(),
    ));
  }
}
