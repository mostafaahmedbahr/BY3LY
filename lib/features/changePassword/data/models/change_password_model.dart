
class ChangePasswordModel {
  bool? status;
  int? number;
  String? message;

  ChangePasswordModel({this.message, this.status, this.number});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    status = json["status"];
    number = json["number"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["status"] = status;
    _data["number"] = number;
    return _data;
  }
}

