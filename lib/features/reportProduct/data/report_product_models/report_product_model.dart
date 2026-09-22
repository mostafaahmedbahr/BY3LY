
class ReportProductComplaintsTypesModel {
  bool? status;
  String? message;
  Data? data;

  ReportProductComplaintsTypesModel({this.status, this.message, this.data});

  ReportProductComplaintsTypesModel.fromJson(Map<String, dynamic> json) {
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
  }

  static List<ReportProductComplaintsTypesModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ReportProductComplaintsTypesModel.fromJson).toList();
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
    if(json["complaints"] is List) {
      complaints = json["complaints"] == null ? null : (json["complaints"] as List).map((e) => Complaints.fromJson(e)).toList();
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(complaints != null) {
      _data["complaints"] = complaints?.map((e) => e.toJson()).toList();
    }
    return _data;
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
    if(json["id"] is num) {
      id = (json["id"] as num).toInt();
    }
    if(json["text"] is String) {
      text = json["text"];
    }
  }

  static List<Complaints> fromList(List<Map<String, dynamic>> list) {
    return list.map(Complaints.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["text"] = text;
    return _data;
  }

  Complaints copyWith({
    int? id,
    String? text,
  }) => Complaints(
    id: id ?? this.id,
    text: text ?? this.text,
  );
}