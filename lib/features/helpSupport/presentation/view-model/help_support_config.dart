/// Help-and-support contact channels — single source of truth for both
/// the labels shown on the tiles and the launchers behind them.
///
/// TODO(product): replace the placeholder email/phone with the real
/// support channels when they are published.
class HelpSupportConfig {
  const HelpSupportConfig._();

  /// Email shown to the user and used as the mailto target.
  static const String email = 'bi3lyapp@example.com';

  /// Phone number exactly as shown on the tile (local Egyptian format).
  static const String phone = '01110690299';

  /// The same number in E.164 so the dialer accepts it everywhere.
  static const String phoneE164 = '+201110690299';

  /// Builds a `mailto:` URI with proper percent-encoding handled by [Uri].
  /// No subject — no trailing query string.
  static Uri buildMailtoUri({String? subject}) {
    final trimmed = subject?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return Uri(scheme: 'mailto', path: email);
    }
    return Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': trimmed},
    );
  }

  /// Builds a `tel:` URI for the support line.
  static Uri buildTelUri() => Uri(scheme: 'tel', path: phoneE164);
}
