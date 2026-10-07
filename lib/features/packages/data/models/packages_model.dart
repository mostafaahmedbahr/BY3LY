String? _asString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

int? _asInt(dynamic value) {
  if (value == null) return null;

  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is num) return value.toInt();

  if (value is String) {
    return int.tryParse(value);
  }

  if (value is bool) {
    return value ? 1 : 0;
  }

  return null;
}

double? _asDouble(dynamic value) {
  if (value == null) return null;

  if (value is num) {
    return value.toDouble();
  }

  if (value is String) {
    return double.tryParse(value);
  }

  return null;
}

bool? _asBool(dynamic value) {
  if (value == null) return null;

  if (value is bool) return value;

  if (value is int) {
    return value != 0;
  }

  if (value is String) {
    final lower = value.toLowerCase().trim();

    if (lower == 'true' || lower == '1') {
      return true;
    }

    if (lower == 'false' || lower == '0') {
      return false;
    }
  }

  return null;
}

List<String>? _asStringList(dynamic value) {
  if (value == null) return null;

  if (value is List) {
    return value
        .map((item) {
          if (item is String) {
            return item.trim();
          }

          if (item is Map) {
            return (item['title'] ??
                    item['name'] ??
                    item['feature'] ??
                    item['text'])
                ?.toString()
                .trim();
          }

          return item?.toString().trim();
        })
        .whereType<String>()
        .where((item) => item.isNotEmpty)
        .toList();
  }

  if (value is String && value.trim().isNotEmpty) {
    return value
        .split(RegExp(r'\n|•|-'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  return null;
}

/// Packages Model
class PackagesModel {
  final bool? status;
  final String? message;
  final Data? data;

  PackagesModel({this.status, this.message, this.data});

  factory PackagesModel.fromJson(Map<String, dynamic> json) {
    return PackagesModel(
      status: _asBool(json['status']),
      message: _asString(json['message']),
      data: json['data'] is Map
          ? Data.fromJson(Map<String, dynamic>.from(json['data']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data?.toJson()};
  }
}

/// Data
class Data {
  final List<Packages>? packages;

  Data({this.packages});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      packages: json['packages'] is List
          ? (json['packages'] as List)
                .whereType<Map>()
                .map(
                  (item) => Packages.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'packages': packages?.map((item) => item.toJson()).toList()};
  }
}

/// Package
class Packages {
  final int? id;
  final String? code;
  final String? name;
  final String? description;
  final double? price;
  final String? currency;
  final int? durationDays;
  final int? adsLimit;
  final bool? isFree;
  final List<String>? features;

  Packages({
    this.id,
    this.code,
    this.name,
    this.description,
    this.price,
    this.currency,
    this.durationDays,
    this.adsLimit,
    this.isFree,
    this.features,
  });

  factory Packages.fromJson(Map<String, dynamic> json) {
    return Packages(
      id: _asInt(json['id']),
      code: _asString(json['code']),
      name: _asString(json['name']),
      description: _asString(json['description']),
      price: _asDouble(json['price']),
      currency: _asString(json['currency']),
      durationDays: _asInt(json['duration_days']),
      adsLimit: _asInt(json['ads_limit']),
      isFree: _asBool(json['is_free']),
      features: _asStringList(json['features']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'duration_days': durationDays,
      'ads_limit': adsLimit,
      'is_free': isFree,
      'features': features,
    };
  }
}

extension PackagesX on Packages {
  /// Maps [durationDays] to the duration tabs (1 / 3 / 6 / 12 months).
  /// 30 days = month, 90 = 3 months, 180 = 6 months, 365 = year.
  int? get durationMonths {
    final d = durationDays;
    if (d == null) return null;
    const exact = {30: 1, 90: 3, 180: 6, 360: 12, 365: 12};
    if (exact.containsKey(d)) return exact[d];
    // Fallback for any other value: nearest tab.
    const tabs = [1, 3, 6, 12];
    final approx = (d / 30).round();
    var nearest = tabs.first;
    for (final t in tabs) {
      if ((t - approx).abs() < (nearest - approx).abs()) nearest = t;
    }
    return nearest;
  }

  /// Arabic label for the duration chip.
  String get durationLabel {
    switch (durationMonths) {
      case 1:
        return 'شهرى';
      case 3:
        return '3 شهور';
      case 6:
        return '6 شهور';
      case 12:
        return 'سنوى';
      default:
        if (durationDays != null) return '$durationDays يوم';
        return '';
    }
  }
}
