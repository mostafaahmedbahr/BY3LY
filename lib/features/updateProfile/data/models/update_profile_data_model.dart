// Tolerant parsing helpers: the API sends the same field as int, String, bool
// or null depending on the endpoint, so every scalar is normalised before it
// reaches a typed field.
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

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

class UpdateProfileDataModel {
  bool? status;
  String? message;
  Data? data;

  UpdateProfileDataModel({this.status, this.message, this.data});

  UpdateProfileDataModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    final raw = json["data"];
    final map = raw == null ? null : _asMap(raw);
    data = map == null ? null : Data.fromJson(map);
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

  Data({this.user});

  Data.fromJson(Map<String, dynamic> json) {
    final rawUser = json["user"];
    final map = rawUser == null ? null : _asMap(rawUser);
    user = map == null ? null : User.fromJson(map);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    if (user != null) {
      jsonData["user"] = user?.toJson();
    }
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

  User({this.id, this.name, this.email, this.phone, this.image, this.token, this.centerId, this.cityId, this.cityName, this.centerName, this.createdAt});

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
