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

if (value is double) {
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
bool? status;
String? message;
Data? data;

PackagesModel({
this.status,
this.message,
this.data,
});

PackagesModel.fromJson(Map<String, dynamic> json) {
status = _asBool(json['status']);
message = _asString(json['message']);

data = json['data'] is Map
? Data.fromJson(
Map<String, dynamic>.from(json['data']),
)
    : null;
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = <String, dynamic>{};

data['status'] = status;
data['message'] = message;

if (this.data != null) {
data['data'] = this.data?.toJson();
}

return data;
}
}


/// Data
class Data {
List<Packages>? packages;

Data({
this.packages,
});

Data.fromJson(Map<String, dynamic> json) {
if (json['packages'] is List) {
packages = (json['packages'] as List)
    .whereType<Map>()
    .map(
(item) => Packages.fromJson(
Map<String, dynamic>.from(item),
),
)
    .toList();
} else {
packages = null;
}
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = <String, dynamic>{};

if (packages != null) {
data['packages'] = packages
    ?.map((item) => item.toJson())
    .toList();
}

return data;
}
}


/// Package
class Packages {
int? id;
String? code;
String? name;
String? description;
double? price;
String? currency;
int? durationDays;
int? adsLimit;
bool? isFree;
bool? isSubscriped;
String? endsAt;
int? remainingAds;
List<String>? features;

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
this.isSubscriped,
this.endsAt,
this.remainingAds,
this.features,
});

Packages.fromJson(Map<String, dynamic> json) {
id = _asInt(json['id']);
code = _asString(json['code']);
name = _asString(json['name']);
description = _asString(json['description']);
price = _asDouble(json['price']);
currency = _asString(json['currency']);
durationDays = _asInt(json['duration_days']);
adsLimit = _asInt(json['ads_limit']);
isFree = _asBool(json['is_free']);
isSubscriped = _asBool(json['is_subscriped']);
endsAt = _asString(json['ends_at']);
remainingAds = _asInt(json['remaining_ads']);
features = _asStringList(json['features']);
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = <String, dynamic>{};

data['id'] = id;
data['code'] = code;
data['name'] = name;
data['description'] = description;
data['price'] = price;
data['currency'] = currency;
data['duration_days'] = durationDays;
data['ads_limit'] = adsLimit;
data['is_free'] = isFree;
data['is_subscriped'] = isSubscriped;
data['ends_at'] = endsAt;
data['remaining_ads'] = remainingAds;
data['features'] = features;

return data;
}
}


/// Packages Extension
extension PackagesX on Packages {
int? get durationMonths {
final d = durationDays;

if (d == null) {
return null;
}

const exact = {
30: 1,
90: 3,
180: 6,
360: 12,
365: 12,
};

if (exact.containsKey(d)) {
return exact[d];
}

const tabs = [1, 3, 6, 12];

final approx = (d / 30).round();

var nearest = tabs.first;

for (final t in tabs) {
if ((t - approx).abs() < (nearest - approx).abs()) {
nearest = t;
}
}

return nearest;
}

String get durationLabel {
switch (durationMonths) {
case 1:
return 'شهري';

case 3:
return '3 شهور';

case 6:
return '6 شهور';

case 12:
return 'سنوي';

default:
if (durationDays != null) {
return '$durationDays يوم';
}

return '';
}
}
}
