
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
    user = json["user"] == null ? null : User.fromJson(json["user"]);
    isActive = json["isActive"];
    requiresOtp = json["requires_otp"];
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