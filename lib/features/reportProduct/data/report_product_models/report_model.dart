// Tolerant parsing: the API sends the same field as int, String, bool or
// null depending on the endpoint, so every value is normalised.
bool? _asBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value.toString().trim().toLowerCase();
  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;
  return null;
}

String? _asString(dynamic value) => value?.toString();

List<T>? _parseList<T>(
  dynamic raw,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (raw is! List) return null;
  final out = <T>[];
  for (final e in raw) {
    if (e is Map) out.add(fromJson(Map<String, dynamic>.from(e)));
  }
  return out;
}

class ReportModel {
  bool? status;
  String? message;
  Data? data;

  ReportModel({this.status, this.message, this.data});

  ReportModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    final raw = json["data"];
    data = raw is Map ? Data.fromJson(Map<String, dynamic>.from(raw)) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["status"] = status;
    jsonData["message"] = message;
    if (data != null) {
      jsonData["data"] = data?.toJson();
    }
    return jsonData;
  }
}

class Data {
  List<Reasons>? reasons;

  Data({this.reasons});

  Data.fromJson(Map<String, dynamic> json) {
    reasons = _parseList(json["reasons"], Reasons.fromJson);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    if (reasons != null) {
      jsonData["reasons"] = reasons?.map((e) => e.toJson()).toList();
    }
    return jsonData;
  }
}

class Reasons {
  String? id;
  String? name;

  Reasons({this.id, this.name});

  Reasons.fromJson(Map<String, dynamic> json) {
    id = _asString(json["id"]);
    name = _asString(json["name"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["name"] = name;
    return jsonData;
  }
}
