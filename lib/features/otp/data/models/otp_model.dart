
class OtpModel {
  bool? status;
  String? message;
  Data? data;

  OtpModel({this.status, this.message, this.data});

  OtpModel.fromJson(Map<String, dynamic> json) {
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
  String? code;
  // Flexible fields - backend may return token/email at data level
  String? email;
  String? token;
  bool? requiresOtp;
  String? otp;
  String? nextStep;

  Data({
    this.user,
    this.isActive,
    this.code,
    this.email,
    this.token,
    this.requiresOtp,
    this.otp,
    this.nextStep,
  });

  Data.fromJson(Map<String, dynamic> json) {
    user = json["user"] == null ? null : User.fromJson(json["user"]);
    isActive = json["isActive"] ?? json["is_active"];
    code = json["code"]?.toString() ?? json["otp"]?.toString();
    email = json["email"]?.toString() ?? user?.email;
    // token can be top-level in data OR inside user
    token = json["token"]?.toString() ??
        json["access_token"]?.toString() ??
        user?.token;
    requiresOtp = json["requires_otp"];
    otp = json["otp"]?.toString();
    nextStep = json["next_step"]?.toString();
  }

  /// Token whatever shape the backend used.
  String? get resolvedToken => token ?? user?.token;

  /// Email whatever shape the backend used.
  String? get resolvedEmail => email ?? user?.email;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(user != null) {
      data["user"] = user?.toJson();
    }
    data["isActive"] = isActive;
    data["code"] = code;
    data["email"] = email;
    data["token"] = token;
    data["requires_otp"] = requiresOtp;
    data["otp"] = otp;
    data["next_step"] = nextStep;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? token;
  int? centerId;
  int? cityId;
  String? cityName;
  String? centerName;
  String? createdAt;

  User({this.id, this.name, this.email, this.phone, this.image, this.token, this.centerId, this.cityId, this.cityName, this.centerName, this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"] is num
        ? (json["id"] as num).toInt()
        : int.tryParse(json["id"]?.toString() ?? "");
    name = json["name"]?.toString();
    email = json["email"]?.toString();
    phone = json["phone"]?.toString();
    image = json["image"]?.toString();
    token = json["token"]?.toString() ?? json["access_token"]?.toString();
    centerId = json["center_id"] is num
        ? (json["center_id"] as num).toInt()
        : int.tryParse(json["center_id"]?.toString() ?? "");
    cityId = json["city_id"] is num
        ? (json["city_id"] as num).toInt()
        : int.tryParse(json["city_id"]?.toString() ?? "");
    cityName = json["cityName"]?.toString() ?? json["city_name"]?.toString();
    centerName =
        json["centerName"]?.toString() ?? json["center_name"]?.toString();
    createdAt = json["created_at"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["email"] = email;
    data["phone"] = phone;
    data["image"] = image;
    data["token"] = token;
    data["center_id"] = centerId;
    data["city_id"] = cityId;
    data["cityName"] = cityName;
    data["centerName"] = centerName;
    data["created_at"] = createdAt;
    return data;
  }
}