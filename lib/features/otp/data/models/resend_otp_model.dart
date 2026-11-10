

String? _asString(dynamic v) => v?.toString();

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
  if (v is num) return v != 0;
  if (v is String) {
    final lower = v.toLowerCase().trim();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}
class ResendOtpModel {
  bool? status;
  String? message;
  Data? data;

  ResendOtpModel({this.status, this.message, this.data});

  ResendOtpModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    final raw = json["data"];
    data = raw is Map ? Data.fromJson(Map<String, dynamic>.from(raw)) : null;
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
    phone = _asString(json["phone"]);
    code = _asInt(json["code"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["phone"] = phone;
    data["code"] = code;
    return data;
  }
}