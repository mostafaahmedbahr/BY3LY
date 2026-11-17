import 'package:by3ly/features/PaymentBalance/presentation/views/payment_and_balance_view.dart';
import 'package:flutter/material.dart';

/// Legacy receipt screen kept for backwards compatibility.
///
/// It never confirmed a transfer locally; it now opens the real top-up flow
/// where the receipt is posted to `wallet/top-up` and verified by the server.
class ConfirmPaymentView extends StatelessWidget {
  const ConfirmPaymentView({super.key});

  @override
  Widget build(BuildContext context) => const PaymentAndBalanceView();
}
