
class GetCarTypesModel {
  bool? status;
  String? message;
  Data? data;

  GetCarTypesModel({this.status, this.message, this.data});

  GetCarTypesModel.fromJson(Map<String, dynamic> json) {
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

  static List<GetCarTypesModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(GetCarTypesModel.fromJson).toList();
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

  GetCarTypesModel copyWith({
    bool? status,
    String? message,
    Data? data,
  }) => GetCarTypesModel(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );
}

class Data {
  List<Typies>? typies;

  Data({this.typies});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["typies"] is List) {
      typies = json["typies"] == null ? null : (json["typies"] as List).map((e) => Typies.fromJson(e)).toList();
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(typies != null) {
      _data["typies"] = typies?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  Data copyWith({
    List<Typies>? typies,
  }) => Data(
    typies: typies ?? this.typies,
  );
}

class Typies {
  int? id;
  String? name;

  Typies({this.id, this.name});

  Typies.fromJson(Map<String, dynamic> json) {
    if(json["id"] is num) {
      id = (json["id"] as num).toInt();
    }
    if(json["name"] is String) {
      name = json["name"];
    }
  }

  static List<Typies> fromList(List<Map<String, dynamic>> list) {
    return list.map(Typies.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }

  Typies copyWith({
    int? id,
    String? name,
  }) => Typies(
    id: id ?? this.id,
    name: name ?? this.name,
  );
}