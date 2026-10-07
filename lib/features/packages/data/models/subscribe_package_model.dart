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
return (
item['title'] ??
item['name'] ??
item['feature'] ??
item['text']
)?.toString().trim();
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


/// Subscribe Package Model
class SubscribePackageModel {
final bool? status;
final String? message;
final SubscribeData? data;

SubscribePackageModel({
this.status,
this.message,
this.data,
});

factory SubscribePackageModel.fromJson(Map<String, dynamic> json) {
return SubscribePackageModel(
status: _asBool(json['status']),
message: _asString(json['message']),
data: json['data'] is Map
? SubscribeData.fromJson(
Map<String, dynamic>.from(json['data']),
)
    : null,
);
}

Map<String, dynamic> toJson() {
return {
'status': status,
'message': message,
'data': data?.toJson(),
};
}
}


/// Subscribe Data
class SubscribeData {
final Subscription? subscription;
final String? paymentUrl;
final bool? isPaid;

SubscribeData({
this.subscription,
this.paymentUrl,
this.isPaid,
});

factory SubscribeData.fromJson(Map<String, dynamic> json) {
return SubscribeData(
subscription: json['subscription'] is Map
? Subscription.fromJson(
Map<String, dynamic>.from(json['subscription']),
)
    : null,
paymentUrl: _asString(json['payment_url']),
isPaid: _asBool(json['is_paid']),
);
}

Map<String, dynamic> toJson() {
return {
'subscription': subscription?.toJson(),
'payment_url': paymentUrl,
'is_paid': isPaid,
};
}
}


/// Subscription
class Subscription {
final int? id;
final String? status;
final double? price;
final String? currency;
final String? paymentMethod;
final String? transferReference;
final String? receiptUrl;
final String? startsAt;
final String? endsAt;
final int? usedAds;
final int? remainingAds;
final int? adsLimit;
final bool? isExpired;
final SubscriptionPackage? package;

Subscription({
this.id,
this.status,
this.price,
this.currency,
this.paymentMethod,
this.transferReference,
this.receiptUrl,
this.startsAt,
this.endsAt,
this.usedAds,
this.remainingAds,
this.adsLimit,
this.isExpired,
this.package,
});

factory Subscription.fromJson(Map<String, dynamic> json) {
return Subscription(
id: _asInt(json['id']),
status: _asString(json['status']),
price: _asDouble(json['price']),
currency: _asString(json['currency']),
paymentMethod: _asString(json['payment_method']),
transferReference: _asString(json['transfer_reference']),
receiptUrl: _asString(json['receipt_url']),
startsAt: _asString(json['starts_at']),
endsAt: _asString(json['ends_at']),
usedAds: _asInt(json['used_ads']),
remainingAds: _asInt(json['remaining_ads']),
adsLimit: _asInt(json['ads_limit']),
isExpired: _asBool(json['is_expired']),
package: json['package'] is Map
? SubscriptionPackage.fromJson(
Map<String, dynamic>.from(json['package']),
)
    : null,
);
}

Map<String, dynamic> toJson() {
return {
'id': id,
'status': status,
'price': price,
'currency': currency,
'payment_method': paymentMethod,
'transfer_reference': transferReference,
'receipt_url': receiptUrl,
'starts_at': startsAt,
'ends_at': endsAt,
'used_ads': usedAds,
'remaining_ads': remainingAds,
'ads_limit': adsLimit,
'is_expired': isExpired,
'package': package?.toJson(),
};
}
}


/// Subscription Package
class SubscriptionPackage {
final int? id;
final String? code;
final String? name;
final String? description;
final int? durationDays;
final int? adsLimit;
final List<String>? features;

SubscriptionPackage({
this.id,
this.code,
this.name,
this.description,
this.durationDays,
this.adsLimit,
this.features,
});

factory SubscriptionPackage.fromJson(Map<String, dynamic> json) {
return SubscriptionPackage(
id: _asInt(json['id']),
code: _asString(json['code']),
name: _asString(json['name']),
description: _asString(json['description']),
durationDays: _asInt(json['duration_days']),
adsLimit: _asInt(json['ads_limit']),
features: _asStringList(json['features']),
);
}

Map<String, dynamic> toJson() {
return {
'id': id,
'code': code,
'name': name,
'description': description,
'duration_days': durationDays,
'ads_limit': adsLimit,
'features': features,
};
}
}
