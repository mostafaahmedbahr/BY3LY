
String? _asString(dynamic v) => v?.toString();

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  if (v is bool) return v ? 1 : 0;
  return null;
}

bool? _asBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is int) return v != 0;
  if (v is String) {
    final lower = v.toLowerCase();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}

class HowToMakePurchaseModel {
  bool? status;
  String? message;
  Data? data;

  HowToMakePurchaseModel({this.status, this.message, this.data});

  HowToMakePurchaseModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]) ?? json["status"] == 1;
    message = _asString(json["message"]);
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
  int? id;
  String? title;
  String? html;
  String? language;
  String? direction;
  String? updatedAt;

  Data({this.id, this.title, this.html, this.language, this.direction, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    title = _asString(json["title"]);
    html = _asString(json["html"]);
    language = _asString(json["language"]);
    direction = _asString(json["direction"]);
    updatedAt = _asString(json["updated_at"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["title"] = title;
    _data["html"] = html;
    _data["language"] = language;
    _data["direction"] = direction;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}