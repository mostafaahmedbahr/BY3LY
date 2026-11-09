import 'package:by3ly/features/addBalance/presentation/view_model/add_balance_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'payment_method_tile.dart';

/// Vodafone Cash deposit via support numbers (manual transfer).
class VodafoneCashTile extends StatelessWidget {
  const VodafoneCashTile({super.key});

  /// Brand-ish red seen on the Vodafone Cash logo.
  static const Color _vodafoneRed = Color(0xffE60000);

  @override
  Widget build(BuildContext context) {
    return PaymentMethodTile(
      icon: Icons.smartphone_rounded,
      tint: _vodafoneRed,
      title: context.tr(LocaleKeys.vodafoneCash),
      subtitle: context.tr(LocaleKeys.now),
      onTap: () => AddBalanceCubit.get(context)
          .showPhoneNumbersDialog(context),
    );
  }
}
