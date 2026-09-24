
class LoginModel {
  bool? status;
  String? message;
  Data? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  int? centerId;
  int? cityId;
  String? cityName;
  String? centerName;
  String? createdAt;

  User({this.id, this.name, this.email, this.phone, this.age, this.image, this.token, this.centerId, this.cityId, this.cityName, this.centerName, this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    age = json["age"];
    image = json["image"];
    token = json["token"];
    centerId = json["center_id"];
    cityId = json["city_id"];
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
    _data["center_id"] = centerId;
    _data["city_id"] = cityId;
    _data["cityName"] = cityName;
    _data["centerName"] = centerName;
    _data["created_at"] = createdAt;
    return _data;
  }
}