
class ReportModel {
  bool? status;
  String? message;
  Data? data;

  ReportModel({this.status, this.message, this.data});

  ReportModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
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
  List<Reasons>? reasons;

  Data({this.reasons});

  Data.fromJson(Map<String, dynamic> json) {
    reasons = json["reasons"] == null ? null : (json["reasons"] as List).map((e) => Reasons.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(reasons != null) {
      _data["reasons"] = reasons?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Reasons {
  String? id;
  String? name;

  Reasons({this.id, this.name});

  Reasons.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}