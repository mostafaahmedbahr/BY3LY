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

class RegisterModel {
  bool? status;
  String? message;
  Data? data;

  RegisterModel({this.status, this.message, this.data});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    final raw = json["data"];
    data = raw is Map ? Data.fromJson(Map<String, dynamic>.from(raw)) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["status"] = status;
    jsonData["message"] = message;
    if (data != null) {
      jsonData["data"] = data?.toJson();
    }
    return jsonData;
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
    final rawUser = json["user"];
    user = rawUser is Map
        ? User.fromJson(Map<String, dynamic>.from(rawUser))
        : null;
    isActive = _asBool(json["isActive"]);
    code = _asString(json["code"]);
    email = _asString(json["email"]) ?? user?.email;
    requiresOtp = _asBool(json["requires_otp"]);
    otp = _asString(json["otp"]);
    nextStep = _asString(json["next_step"]);
    purpose = _asString(json["purpose"]);
    expiresIn = _asInt(json["expires_in"]);
  }

  /// Returns the OTP/code whatever key the backend used.
  String? get activationCode => otp ?? code;

  /// Returns the email whatever shape the backend used.
  String? get resolvedEmail => email ?? user?.email;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    if (user != null) {
      jsonData["user"] = user?.toJson();
    }
    jsonData["isActive"] = isActive;
    jsonData["code"] = code;
    jsonData["email"] = email;
    jsonData["requires_otp"] = requiresOtp;
    jsonData["otp"] = otp;
    jsonData["next_step"] = nextStep;
    jsonData["purpose"] = purpose;
    jsonData["expires_in"] = expiresIn;
    return jsonData;
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

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.token,
    this.centerId,
    this.cityId,
    this.cityName,
    this.centerName,
    this.createdAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    name = _asString(json["name"]);
    email = _asString(json["email"]);
    phone = _asString(json["phone"]);
    image = _asString(json["image"]);
    token = _asString(json["token"]);
    centerId = _asInt(json["center_id"]);
    cityId = _asInt(json["city_id"]);
    cityName = _asString(json["cityName"]);
    centerName = _asString(json["centerName"]);
    createdAt = _asString(json["created_at"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["name"] = name;
    jsonData["email"] = email;
    jsonData["phone"] = phone;
    jsonData["image"] = image;
    jsonData["token"] = token;
    jsonData["center_id"] = centerId;
    jsonData["city_id"] = cityId;
    jsonData["cityName"] = cityName;
    jsonData["centerName"] = centerName;
    jsonData["created_at"] = createdAt;
    return jsonData;
  }
}
