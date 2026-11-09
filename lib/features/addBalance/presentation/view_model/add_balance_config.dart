/// Shared constants for the manual add-balance screen.
///
/// Single source of truth consumed by the view, the cubit and the tests,
/// so the numbers can never drift apart across files.
class AddBalanceConfig {
  AddBalanceConfig._();

  /// Support numbers customers can call / send to for manual deposit.
  /// Replace with the real support channels before going live.
  static const List<String> supportPhoneNumbers = [
    '+1234567890',
    '+0987654321',
    '+1122334455',
  ];

  /// Bank account used for Instapay transfers (manual verification).
  static const String accountNumber = '123456789023';
}
