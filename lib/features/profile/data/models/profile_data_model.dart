
class ProfileModel {
  bool? status;
  String? message;
  Data? data;

  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  User? user;
  bool? isActive;
  bool? requiresOtp;

  Data({this.user, this.isActive, this.requiresOtp});

  Data.fromJson(Map<String, dynamic> json) {
    user = json["user"] == null ? null : User.fromJson(json["user"]);
    isActive = json["isActive"];
    requiresOtp = json["requires_otp"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(user != null) {
      _data["user"] = user?.toJson();
    }
    _data["isActive"] = isActive;
    _data["requires_otp"] = requiresOtp;
    return _data;
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
    id = (json["id"] as num).toInt();
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    age = json["age"];
    image = json["image"];
    token = json["token"];
    walletBalance = (json["wallet_balance"] as num).toInt();
    walletCurrency = json["wallet_currency"];
    subscriptionPackage = json["subscription_package"] == null ? null : SubscriptionPackage.fromJson(json["subscription_package"]);
    centerId = (json["center_id"] as num).toInt();
    cityId = (json["city_id"] as num).toInt();
    cityName = json["cityName"];
    centerName = json["centerName"];
    createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["email"] = email;
    _data["phone"] = phone;
    _data["age"] = age;
    _data["image"] = image;
    _data["token"] = token;
    _data["wallet_balance"] = walletBalance;
    _data["wallet_currency"] = walletCurrency;
    if(subscriptionPackage != null) {
      _data["subscription_package"] = subscriptionPackage?.toJson();
    }
    _data["center_id"] = centerId;
    _data["city_id"] = cityId;
    _data["cityName"] = cityName;
    _data["centerName"] = centerName;
    _data["created_at"] = createdAt;
    return _data;
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
    id = (json["id"] as num).toInt();
    code = json["code"];
    name = json["name"];
    description = json["description"];
    price = (json["price"] as num).toInt();
    currency = json["currency"];
    durationDays = (json["duration_days"] as num).toInt();
    adsLimit = (json["ads_limit"] as num).toInt();
    features = json["features"] == null ? null : List<String>.from(json["features"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["code"] = code;
    _data["name"] = name;
    _data["description"] = description;
    _data["price"] = price;
    _data["currency"] = currency;
    _data["duration_days"] = durationDays;
    _data["ads_limit"] = adsLimit;
    if(features != null) {
      _data["features"] = features;
    }
    return _data;
  }
}