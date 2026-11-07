/// GET /api/ad-publishing-settings → the fixed publishing fee and the
/// transfer accounts it can be paid to (same shape the website reads).
class AdPublishingSettingsModel {
  AdPublishingSettingsModel({
    this.price,
    this.currency,
    this.paymentMethods = const [],
  });

  final double? price;
  final String? currency;
  final List<AdPublishingPaymentMethod> paymentMethods;

  /// Display label for the currency ("EGP" → "ج.م").
  String get currencyLabel {
    switch (currency) {
      case 'EGP':
        return 'ج.م';
      case null:
      case '':
        return 'ج.م';
      default:
        return currency!;
    }
  }

  /// "10 ج.م" — null when the price is missing.
  String? get priceLabel {
    final value = price;
    if (value == null) return null;
    final text = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
    return '$text $currencyLabel';
  }

  factory AdPublishingSettingsModel.fromJson(Map<String, dynamic> json) {
    final dynamic raw = json['data'] is Map<String, dynamic>
        ? json['data']
        : json;

    double? price;
    if (raw is Map<String, dynamic>) {
      final value = raw['price'];
      if (value is num) {
        price = value.toDouble();
      } else if (value is String) {
        price = double.tryParse(value);
      }
      final methods = raw['payment_methods'];
      return AdPublishingSettingsModel(
        price: price,
        currency: raw['currency']?.toString(),
        paymentMethods: methods is List
            ? methods
                .whereType<Map<String, dynamic>>()
                .map(AdPublishingPaymentMethod.fromJson)
                .toList()
            : const [],
      );
    }
    return AdPublishingSettingsModel(paymentMethods: const []);
  }
}

class AdPublishingPaymentMethod {
  AdPublishingPaymentMethod({this.code, this.account});

  final String? code;
  final String? account;

  factory AdPublishingPaymentMethod.fromJson(Map<String, dynamic> json) {
    return AdPublishingPaymentMethod(
      code: json['code']?.toString(),
      account: json['account']?.toString(),
    );
  }
}
