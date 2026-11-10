
String? _asString(dynamic v) => v?.toString();

bool? _asBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final lower = v.toLowerCase().trim();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}

class OtpModel {
  bool? status;
  String? message;
  Data? data;

  OtpModel({this.status, this.message, this.data});

  OtpModel.fromJson(Map<String, dynamic> json) {
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
    final rawUser = json["user"];
    user = rawUser is Map
        ? User.fromJson(Map<String, dynamic>.from(rawUser))
        : null;
    isActive = _asBool(json["isActive"]) ?? _asBool(json["is_active"]);
    code = _asString(json["code"] ?? json["otp"]);
    email = _asString(json["email"]) ?? user?.email;
    // token can be top-level in data OR inside user
    token = _asString(json["token"]) ?? _asString(json["access_token"]) ?? user?.token;
    requiresOtp = _asBool(json["requires_otp"]);
    otp = _asString(json["otp"]);
    nextStep = _asString(json["next_step"]);
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