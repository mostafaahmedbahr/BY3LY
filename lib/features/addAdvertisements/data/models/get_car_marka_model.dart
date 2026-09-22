
class GetCarMarkaModel {
  bool? status;
  String? message;
  Data? data;

  GetCarMarkaModel({this.status, this.message, this.data});

  GetCarMarkaModel.fromJson(Map<String, dynamic> json) {
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

  static List<GetCarMarkaModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(GetCarMarkaModel.fromJson).toList();
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

  GetCarMarkaModel copyWith({
    bool? status,
    String? message,
    Data? data,
  }) => GetCarMarkaModel(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );
}

class Data {
  List<Marka>? marka;

  Data({this.marka});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["marka"] is List) {
      marka = json["marka"] == null ? null : (json["marka"] as List).map((e) => Marka.fromJson(e)).toList();
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(marka != null) {
      _data["marka"] = marka?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  Data copyWith({
    List<Marka>? marka,
  }) => Data(
    marka: marka ?? this.marka,
  );
}

class Marka {
  int? id;
  String? name;

  Marka({this.id, this.name});

  Marka.fromJson(Map<String, dynamic> json) {
    if(json["id"] is num) {
      id = (json["id"] as num).toInt();
    }
    if(json["name"] is String) {
      name = json["name"];
    }
  }

  static List<Marka> fromList(List<Map<String, dynamic>> list) {
    return list.map(Marka.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }

  Marka copyWith({
    int? id,
    String? name,
  }) => Marka(
    id: id ?? this.id,
    name: name ?? this.name,
  );
}