// Safe parsing helpers: the API sends the same field as int, String, bool
// or null depending on the endpoint, so every scalar is normalised.
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


class DeleteAccountModel {
  bool? status;
  int? number;
  String? message;

  DeleteAccountModel({this.status, this.number, this.message});

  DeleteAccountModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    number = _asInt(json["number"]);
    message = json["message"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["number"] = number;
    data["message"] = message;
    return data;
  }
}