String? _asString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

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

/// `ends_at` has already passed → the package can no longer cover a publish.
/// An absent / unparseable date never blocks publishing: the server is
/// still the final authority (it rejects the ad with the payment fields
/// error when the package is actually gone).
bool _endsAtPassed(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) return false;

  DateTime? end;
  // Date-only values ("2026-12-31") stay valid for the whole day.
  if (text.length == 10) {
    final day = DateTime.tryParse(text);
    if (day != null) {
      end = DateTime(day.year, day.month, day.day, 23, 59, 59);
    }
  }
  end ??= DateTime.tryParse(text);
  if (end == null) return false;
  return !end.isAfter(DateTime.now());
}

/// GET /api/subscriptions/current — the active subscription used to
/// decide whether publishing a new ad is free (deducted from the
/// package, never from the wallet / balance).
///
/// Rule: while `remaining_ads > 0` and `ends_at` hasn't arrived yet the
/// ad is posted directly, without any payment field. Once the ads in
/// the package run out (or it expires) the payment step takes over.
class CurrentSubscriptionModel {
  CurrentSubscriptionModel({
    this.status,
    this.isExpired,
    this.adsLimit,
    this.usedAds,
    this.remainingAds,
    this.endsAt,
    this.hasSubscription = false,
  });

  final String? status;
  final bool? isExpired;
  final int? adsLimit;
  final int? usedAds;

  /// The `remaining_ads` key from `subscriptions/current`: the number of
  /// ads still available in the subscribed package.
  final int? remainingAds;

  /// `ends_at` from the same response; used to ignore expired packages
  /// even when the server still reports ads left.
  final String? endsAt;

  /// False when the response carries no subscription at all — an empty
  /// model must never be mistaken for an unlimited package.
  final bool hasSubscription;

  bool get isEnded => _endsAtPassed(endsAt);

  /// true → publish straight away (deducted from the package);
  /// false → package is exhausted / expired → payment required.
  bool get isCovered {
    if (!hasSubscription || isExpired == true || isEnded) return false;

    // Main rule: the package still has ads in it.
    final remaining = remainingAds;
    if (remaining != null) return remaining > 0;

    // Older responses without `remaining_ads`: no limit means unlimited,
    // otherwise compare the used count against the limit.
    if (adsLimit == null || adsLimit! <= 0) return true;
    return (usedAds ?? 0) < adsLimit!;
  }

  factory CurrentSubscriptionModel.fromJson(Map<String, dynamic> json) {
    // Envelope {status, data:{...}} or a bare subscription object — the
    // status may be a string ("active"/"success") or a bool, so don't
    // depend on its type to find the payload.
    final dynamic data = json['data'];
    final dynamic raw = data is Map ? Map<String, dynamic>.from(data) : json;

    if (raw is! Map<String, dynamic>) {
      return CurrentSubscriptionModel();
    }
    // No subscription-like fields at all → no active package.
    if (!raw.containsKey('remaining_ads') &&
        !raw.containsKey('ads_limit') &&
        !raw.containsKey('ends_at') &&
        !raw.containsKey('is_expired')) {
      return CurrentSubscriptionModel();
    }

    return CurrentSubscriptionModel(
      status: _asString(raw['status']),
      isExpired: _asBool(raw['is_expired']),
      adsLimit: _asInt(raw['ads_limit']),
      usedAds: _asInt(raw['used_ads']),
      remainingAds: _asInt(raw['remaining_ads']),
      endsAt: _asString(raw['ends_at']),
      hasSubscription: true,
    );
  }
}
