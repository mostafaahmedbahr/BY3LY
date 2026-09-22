
class ResendOtpModel {
  bool? status;
  String? message;
  Data? data;

  ResendOtpModel({this.status, this.message, this.data});

  ResendOtpModel.fromJson(Map<String, dynamic> json) {
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
  String? phone;
  int? code;

  Data({this.phone, this.code});

  Data.fromJson(Map<String, dynamic> json) {
    phone = json["phone"];
    code = (json["code"] as num).toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["phone"] = phone;
    _data["code"] = code;
    return _data;
  }
}