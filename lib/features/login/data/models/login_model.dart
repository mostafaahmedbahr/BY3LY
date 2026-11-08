
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