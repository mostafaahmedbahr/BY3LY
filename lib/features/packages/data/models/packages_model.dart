String? _asString(dynamic v) => v?.toString();

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  if (v is bool) return v ? 1 : 0;
  return null;
}

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

bool? _asBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is int) return v != 0;
  if (v is String) {
    final lower = v.toLowerCase();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}

List<String>? _asStringList(dynamic v) {
  if (v == null) return null;
  if (v is List) {
    return v
        .map((e) {
          if (e is String) return e.trim();
          if (e is Map) {
            // {title: ..} / {name: ..} / {feature: ..} shapes.
            final m = e;
            return (m['title'] ?? m['name'] ?? m['feature'] ?? m['text'])
                ?.toString()
                .trim();
          }
          return e?.toString().trim();
        })
        .where((e) => (e?.isNotEmpty ?? false))
        .cast<String>()
        .toList();
  }
  if (v is String && v.trim().isNotEmpty) {
    return v
        .split(RegExp(r'\n|•|-'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
  return null;
}

class PackagesModel {
  bool? status;
  String? message;
  List<Package>? data;

  PackagesModel({this.status, this.message, this.data});

  PackagesModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json['status']) ?? json['status'] == 1;
    message = _asString(json['message']);
    final raw = json['data'];
    if (raw is List) {
      data = raw.map((e) => Package.fromJson(e)).toList();
    } else if (raw is Map<String, dynamic>) {
      final list = raw['packages'] ?? raw['data'] ?? raw['items'];
      if (list is List) {
        data = list.map((e) => Package.fromJson(e)).toList();
      }
    } else if (json['packages'] is List) {
      data =
          (json['packages'] as List).map((e) => Package.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((e) => e.toJson()).toList();
    }
    return map;
  }
}

class Package {
  int? id;
  String? name;
  String? desc;
  double? price;
  double? oldPrice;
  String? currency;
  String? duration;
  int? durationMonths;
  String? durationLabel;
  List<String>? features;
  int? adsCount;
  bool? isPopular;

  Package({
    this.id,
    this.name,
    this.desc,
    this.price,
    this.oldPrice,
    this.currency,
    this.duration,
    this.durationMonths,
    this.durationLabel,
    this.features,
    this.adsCount,
    this.isPopular,
  });

  Package.fromJson(Map<String, dynamic> json) {
    id = _asInt(json['id']);
    name = _asString(json['name'] ?? json['title'] ?? json['package_name']);
    desc = _asString(
        json['description'] ?? json['desc'] ?? json['details']);
    price = _asDouble(json['price']);
    oldPrice = _asDouble(json['old_price'] ?? json['oldPrice']);
    currency = _asString(json['currency']);
    duration = _asString(
        json['duration'] ?? json['type'] ?? json['period']);
    durationMonths = _asInt(json['duration_months'] ??
        json['months'] ??
        json['period_months']);
    durationLabel = _asString(
            json['duration_label'] ?? json['durationLabel']) ??
        duration;
    features = _asStringList(json['features'] ??
        json['points'] ??
        json['advantages'] ??
        json['details_list']);
    adsCount =
        _asInt(json['ads_count'] ?? json['adsCount'] ?? json['ads_number']);
    isPopular = _asBool(json['is_popular'] ??
            json['isPopular'] ??
            json['is_recommended'] ??
            json['popular'] ??
            json['recommended'] ??
            json['best_seller']) ??
        false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = desc;
    map['price'] = price;
    map['old_price'] = oldPrice;
    map['currency'] = currency;
    map['duration'] = duration;
    map['duration_months'] = durationMonths;
    map['duration_label'] = durationLabel;
    map['features'] = features;
    map['ads_count'] = adsCount;
    map['is_popular'] = isPopular;
    return map;
  }

  /// Whether this package carries any duration info to filter on.
  bool get hasDurationInfo =>
      (duration?.trim().isNotEmpty ?? false) || durationMonths != null;

  /// Matches a package against a duration tab (months: 1 / 3 / 6 / 12).
  bool matchesDuration(int months) {
    if (durationMonths != null) return durationMonths == months;
    final d = (duration ?? '').trim().toLowerCase();
    if (d.isEmpty) return false;
    // Explicit number in the text (1 / 3 / 6 / 12 ...).
    final digit = RegExp(r'\d+').firstMatch(d);
    if (digit != null) {
      final n = int.tryParse(digit.group(0)!);
      if (n != null) return n == months;
    }
    if (months == 1) {
      return d.contains('month') || d.contains('شهر');
    }
    if (months == 3) {
      return d.contains('quarter');
    }
    if (months == 6) {
      return d.contains('semi') ||
          d.contains('half') ||
          d.contains('نصف');
    }
    return d.contains('year') ||
        d.contains('annual') ||
        d.contains('سنو');
  }
}
