String? _asString(dynamic v) => v?.toString();

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is bool) return v ? 1 : 0;
  if (v is String) return int.tryParse(v.trim());
  return null;
}

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

/// Login envelope: { status, message, data: { user, isActive, requires_otp } }.
/// Fully tolerant — `1/"true"/true` semantics, numeric ids as strings.
class LoginModel {
  bool? status;
  String? message;
  Data? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    final raw = json["data"];
    if (raw is Map) {
      data = Data.fromJson(Map<String, dynamic>.from(raw));
    } else {
      data = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result["status"] = status;
    result["message"] = message;
    if (data != null) {
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
    if (user != null) {
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
  int? centerId;
  int? cityId;
  String? cityName;
  String? centerName;
  String? createdAt;

  User({this.id, this.name, this.email, this.phone, this.age, this.image, this.token, this.centerId, this.cityId, this.cityName, this.centerName, this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    name = _asString(json["name"]);
    email = _asString(json["email"]);
    phone = _asString(json["phone"]);
    age = json["age"];
    image = _asString(json["image"]);
    token = _asString(json["token"]);
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
    data["center_id"] = centerId;
    data["city_id"] = cityId;
    data["cityName"] = cityName;
    data["centerName"] = centerName;
    data["created_at"] = createdAt;
    return data;
  }
}
