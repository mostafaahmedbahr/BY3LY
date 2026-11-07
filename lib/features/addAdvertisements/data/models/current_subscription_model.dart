String? _asString(dynamic value) => value?.toString();

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  if (value is bool) return value ? 1 : 0;
  return null;
}

bool? _asBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}

/// GET /api/subscriptions/current — the active subscription used to
/// decide whether publishing a new ad is free.
///
/// Same rule the website applies before allowing a direct publish:
/// the subscription is active, not expired, and either unlimited
/// (no ads_limit) or still has remaining ads.
class CurrentSubscriptionModel {
  CurrentSubscriptionModel({
    this.status,
    this.isExpired,
    this.adsLimit,
    this.usedAds,
    this.remainingAds,
  });

  final String? status;
  final bool? isExpired;
  final int? adsLimit;
  final int? usedAds;
  final int? remainingAds;

  /// true → publish is covered by the package (free);
  /// false → the package/free ads are exhausted → payment required.
  bool get isCovered =>
      status == 'active' &&
      isExpired != true &&
      (adsLimit == null || adsLimit! <= 0 || (remainingAds ?? 0) > 0);

  factory CurrentSubscriptionModel.fromJson(Map<String, dynamic> json) {
    // Envelope {status, data:{...}} or the bare subscription object.
    final dynamic raw = json['data'] is Map<String, dynamic>
        ? json['data']
        : (json['status'] is String ? json : null);

    if (raw is! Map<String, dynamic>) {
      // No subscription at all → not covered.
      return CurrentSubscriptionModel();
    }
    return CurrentSubscriptionModel(
      status: _asString(raw['status']),
      isExpired: _asBool(raw['is_expired']),
      adsLimit: _asInt(raw['ads_limit']),
      usedAds: _asInt(raw['used_ads']),
      remainingAds: _asInt(raw['remaining_ads']),
    );
  }
}
