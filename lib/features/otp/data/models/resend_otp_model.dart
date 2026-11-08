
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
  String? phone;
  int? code;

  Data({this.phone, this.code});

  Data.fromJson(Map<String, dynamic> json) {
    phone = json["phone"];
    code = (json["code"] as num).toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["phone"] = phone;
    data["code"] = code;
    return data;
  }
}