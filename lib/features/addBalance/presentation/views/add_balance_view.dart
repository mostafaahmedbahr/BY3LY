import 'package:by3ly/features/PaymentBalance/presentation/views/payment_and_balance_view.dart';
import 'package:flutter/material.dart';

/// Legacy entry point kept for backwards compatibility. It now opens the
/// server-verified wallet/top-up screen instead of hardcoded transfer details.
class AddBalanceView extends StatelessWidget {
  const AddBalanceView({super.key});

  @override
  Widget build(BuildContext context) => const PaymentAndBalanceView();
}
