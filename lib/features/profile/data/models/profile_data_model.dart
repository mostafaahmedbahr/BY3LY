// Safe parsing helpers: the API sends the same field as int, String, bool
// or null depending on the endpoint, so every scalar is normalised before
// it reaches a typed field.
bool? _asBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value.toString().trim().toLowerCase();
  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;
  return null;
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString().trim());
}

String? _asString(dynamic value) => value?.toString();


class ProfileModel {
  bool? status;
  String? message;
  Data? data;

  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    final raw = json["data"];
    data = raw is Map ? Data.fromJson(Map<String, dynamic>.from(raw)) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result["status"] = status;
    result["message"] = message;
    if(data != null) {
      result["data"] = data?.toJson();
    }
    return result;
  }
}

class Data {
  User? user;
  bool? isActive;
  bool? requiresOtp;

  Data({this.user, this.isActive, this.requiresOtp});

  Data.fromJson(Map<String, dynamic> json) {
    final rawUser = json["user"];
    user = rawUser is Map
        ? User.fromJson(Map<String, dynamic>.from(rawUser))
        : null;
    isActive = _asBool(json["isActive"]);
    requiresOtp = _asBool(json["requires_otp"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(user != null) {
      data["user"] = user?.toJson();
    }
    data["isActive"] = isActive;
    data["requires_otp"] = requiresOtp;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  dynamic age;
  String? image;
  String? token;
  int? walletBalance;
  String? walletCurrency;
  SubscriptionPackage? subscriptionPackage;
  int? centerId;
  int? cityId;
  String? cityName;
  String? centerName;
  String? createdAt;

  User({this.id, this.name, this.email, this.phone, this.age, this.image, this.token, this.walletBalance, this.walletCurrency, this.subscriptionPackage, this.centerId, this.cityId, this.cityName, this.centerName, this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    name = _asString(json["name"]);
    email = _asString(json["email"]);
    phone = _asString(json["phone"]);
    age = json["age"];
    image = _asString(json["image"]);
    token = _asString(json["token"]);
    walletBalance = _asInt(json["wallet_balance"]);
    walletCurrency = _asString(json["wallet_currency"]);
    final rawPackage = json["subscription_package"];
    subscriptionPackage = rawPackage is Map
        ? SubscriptionPackage.fromJson(Map<String, dynamic>.from(rawPackage))
        : null;
    centerId = _asInt(json["center_id"]);
    cityId = _asInt(json["city_id"]);
    cityName = _asString(json["cityName"]);
    centerName = _asString(json["centerName"]);
    createdAt = _asString(json["created_at"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["email"] = email;
    data["phone"] = phone;
    data["age"] = age;
    data["image"] = image;
    data["token"] = token;
    data["wallet_balance"] = walletBalance;
    data["wallet_currency"] = walletCurrency;
    if(subscriptionPackage != null) {
      data["subscription_package"] = subscriptionPackage?.toJson();
    }
    data["center_id"] = centerId;
    data["city_id"] = cityId;
    data["cityName"] = cityName;
    data["centerName"] = centerName;
    data["created_at"] = createdAt;
    return data;
  }
}

class SubscriptionPackage {
  int? id;
  String? code;
  String? name;
  String? description;
  int? price;
  String? currency;
  int? durationDays;
  int? adsLimit;
  List<String>? features;

  SubscriptionPackage({this.id, this.code, this.name, this.description, this.price, this.currency, this.durationDays, this.adsLimit, this.features});

  SubscriptionPackage.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    code = _asString(json["code"]);
    name = _asString(json["name"]);
    description = _asString(json["description"]);
    price = _asInt(json["price"]);
    currency = _asString(json["currency"]);
    durationDays = _asInt(json["duration_days"]);
    adsLimit = _asInt(json["ads_limit"]);
    final rawFeatures = json["features"];
    features = rawFeatures is List
        ? rawFeatures.map((e) => e.toString()).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["code"] = code;
    data["name"] = name;
    data["description"] = description;
    data["price"] = price;
    data["currency"] = currency;
    data["duration_days"] = durationDays;
    data["ads_limit"] = adsLimit;
    if(features != null) {
      data["features"] = features;
    }
    return data;
  }
}