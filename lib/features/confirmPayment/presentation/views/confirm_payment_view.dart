import 'package:by3ly/features/confirmPayment/presentation/views/confirm_payment_widgets/confirm_payment_view_body.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors/app_colors.dart';

class ConfirmPaymentView extends StatelessWidget {
  const ConfirmPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor: AppColors.mainColor,
        title:   Text( LocaleKeys.confirmPayment.tr(),style: const TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: const ConfirmPaymentViewBody(),
    ));
  }
}
