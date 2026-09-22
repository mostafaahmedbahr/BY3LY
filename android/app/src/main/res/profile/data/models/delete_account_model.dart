
class DeleteAccountModel {
  bool? status;
  int? number;
  String? message;

  DeleteAccountModel({this.status, this.number, this.message});

  DeleteAccountModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    number = (json["number"] as num).toInt();
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["number"] = number;
    _data["message"] = message;
    return _data;
  }
}