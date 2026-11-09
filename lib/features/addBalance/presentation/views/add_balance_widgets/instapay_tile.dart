import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'instapay_sheet.dart';
import 'payment_method_tile.dart';

/// Instapay deposit via bank account (manual transfer).
class InstapayTile extends StatelessWidget {
  const InstapayTile({super.key});

  /// Brand-ish purple used by InstaPay.
  static const Color _instaPayPurple = Color(0xff5B2C86);

  @override
  Widget build(BuildContext context) {
    return PaymentMethodTile(
      icon: Icons.flash_on_rounded,
      tint: _instaPayPurple,
      title: context.tr(LocaleKeys.instaPay),
      subtitle: context.tr(LocaleKeys.now),
      onTap: () => InstapaySheet.show(context),
    );
  }
}
