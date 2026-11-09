/// Change password API response. Tolerant parsing — the backend may send
/// `status` as bool or 0/1, `number` as num or string.
class ChangePasswordModel {
  bool? status;
  int? number;
  String? message;

  ChangePasswordModel({this.message, this.status, this.number});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    message = json["message"]?.toString();
    number = _asInt(json["number"]);
    status = _asBool(json["status"]);
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData["message"] = message;
    jsonData["status"] = status;
    jsonData["number"] = number;
    return jsonData;
  }
}

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
  if (v is int) return v != 0;
  if (v is String) {
    final l = v.toLowerCase().trim();
    if (l == 'true' || l == '1') return true;
    if (l == 'false' || l == '0') return false;
  }
  return null;
}
