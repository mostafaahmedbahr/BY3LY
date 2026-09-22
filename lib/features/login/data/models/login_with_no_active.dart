
class LoginWithNoActive {
  bool? status;
  String? message;
  Data? data;

  LoginWithNoActive({this.status, this.message, this.data});

  LoginWithNoActive.fromJson(Map<String, dynamic> json) {
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
  String? email;
  int? code;
  bool? isActive;

  Data({this.email, this.code, this.isActive});

  Data.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    code = (json["code"] as num).toInt();
    isActive = json["isActive"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["email"] = email;
    _data["code"] = code;
    _data["isActive"] = isActive;
    return _data;
  }
}