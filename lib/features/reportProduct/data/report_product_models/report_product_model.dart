// Tolerant parsing: the API sends the same field as int, String, bool or
// null depending on the endpoint, so every value is normalised before it
// reaches a typed field.
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

class ReportProductComplaintsTypesModel {
  bool? status;
  String? message;
  Data? data;

  ReportProductComplaintsTypesModel({this.status, this.message, this.data});

  ReportProductComplaintsTypesModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    final raw = json["data"];
    data = raw is Map ? Data.fromJson(Map<String, dynamic>.from(raw)) : null;
  }

  static List<ReportProductComplaintsTypesModel> fromList(
      List<Map<String, dynamic>> list) {
    return list.map(ReportProductComplaintsTypesModel.fromJson).toList();
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

  ReportProductComplaintsTypesModel copyWith({
    bool? status,
    String? message,
    Data? data,
  }) => ReportProductComplaintsTypesModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );
}

class Data {
  List<Complaints>? complaints;

  Data({this.complaints});

  Data.fromJson(Map<String, dynamic> json) {
    complaints = _parseList(json["complaints"], Complaints.fromJson);
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    if (complaints != null) {
      jsonData["complaints"] = complaints?.map((e) => e.toJson()).toList();
    }
    return jsonData;
  }

  Data copyWith({
    List<Complaints>? complaints,
  }) => Data(
        complaints: complaints ?? this.complaints,
      );
}

class Complaints {
  int? id;
  String? text;

  Complaints({this.id, this.text});

  Complaints.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    text = _asString(json["text"]);
  }

  static List<Complaints> fromList(List<Map<String, dynamic>> list) {
    return list.map(Complaints.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["text"] = text;
    return jsonData;
  }

  Complaints copyWith({
    int? id,
    String? text,
  }) => Complaints(
        id: id ?? this.id,
        text: text ?? this.text,
      );
}
