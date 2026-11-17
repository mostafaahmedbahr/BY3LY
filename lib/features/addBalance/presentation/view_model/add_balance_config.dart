import '../../../helpSupport/presentation/view-model/help_support_config.dart';

/// Legacy manual-deposit screen configuration.
///
/// Deposits are no longer confirmed locally: the supported flow is
/// `wallet/top-up` with a receipt reviewed by the backend. No placeholder
/// transfer numbers or bank accounts are shipped to users.
class AddBalanceConfig {
  AddBalanceConfig._();

  /// Real support line only — used for assistance, never as a deposit target.
  static const List<String> supportPhoneNumbers = [HelpSupportConfig.phoneE164];

  /// Intentionally empty: accounts come from `GET payment-methods` on the
  /// server. Kept as a build-time override for private/staging deployments.
  static const String accountNumber = String.fromEnvironment(
    'BI3LY_INSTAPAY_ACCOUNT',
    defaultValue: '',
  );
}
