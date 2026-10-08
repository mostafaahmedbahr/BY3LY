
class RegisterModel {
  bool? status;
  String? message;
  Data? data;

  RegisterModel({this.status, this.message, this.data});

  RegisterModel.fromJson(Map<String, dynamic> json) {
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
  String? code;
  // New API (activation flow) fields
  String? email;
  bool? requiresOtp;
  String? otp;
  String? nextStep;
  String? purpose;
  int? expiresIn;

  Data({
    this.user,
    this.isActive,
    this.code,
    this.email,
    this.requiresOtp,
    this.otp,
    this.nextStep,
    this.purpose,
    this.expiresIn,
  });

  Data.fromJson(Map<String, dynamic> json) {
    user = json["user"] == null ? null : User.fromJson(json["user"]);
    isActive = json["isActive"];
    code = json["code"]?.toString();
    email = json["email"]?.toString() ?? user?.email;
    requiresOtp = json["requires_otp"];
    otp = json["otp"]?.toString();
    nextStep = json["next_step"]?.toString();
    purpose = json["purpose"]?.toString();
    expiresIn = json["expires_in"] is num
        ? (json["expires_in"] as num).toInt()
        : int.tryParse(json["expires_in"]?.toString() ?? "");
  }

  /// Returns the OTP/code whatever key the backend used.
  String? get activationCode => otp ?? code;

  /// Returns the email whatever shape the backend used.
  String? get resolvedEmail => email ?? user?.email;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(user != null) {
      _data["user"] = user?.toJson();
    }
    _data["isActive"] = isActive;
    _data["code"] = code;
    _data["email"] = email;
    _data["requires_otp"] = requiresOtp;
    _data["otp"] = otp;
    _data["next_step"] = nextStep;
    _data["purpose"] = purpose;
    _data["expires_in"] = expiresIn;
    return _data;
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
    id = json["id"] is num ? (json["id"] as num).toInt() : int.tryParse(json["id"]?.toString() ?? "");
    name = json["name"]?.toString();
    email = json["email"]?.toString();
    phone = json["phone"]?.toString();
    image = json["image"]?.toString();
    token = json["token"]?.toString();
    centerId = json["center_id"] is num
        ? (json["center_id"] as num).toInt()
        : int.tryParse(json["center_id"]?.toString() ?? "");
    cityId = json["city_id"] is num
        ? (json["city_id"] as num).toInt()
        : int.tryParse(json["city_id"]?.toString() ?? "");
    cityName = json["cityName"]?.toString();
    centerName = json["centerName"]?.toString();
    createdAt = json["created_at"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["email"] = email;
    _data["phone"] = phone;
    _data["image"] = image;
    _data["token"] = token;
    _data["center_id"] = centerId;
    _data["city_id"] = cityId;
    _data["cityName"] = cityName;
    _data["centerName"] = centerName;
    _data["created_at"] = createdAt;
    return _data;
  }
}