
class GetCarModelsModel {
  bool? status;
  String? message;
  Data? data;

  GetCarModelsModel({this.status, this.message, this.data});

  GetCarModelsModel.fromJson(Map<String, dynamic> json) {
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

  static List<GetCarModelsModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(GetCarModelsModel.fromJson).toList();
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

  GetCarModelsModel copyWith({
    bool? status,
    String? message,
    Data? data,
  }) => GetCarModelsModel(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );
}

class Data {
  List<Models>? models;

  Data({this.models});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["models"] is List) {
      models = json["models"] == null ? null : (json["models"] as List).map((e) => Models.fromJson(e)).toList();
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(models != null) {
      _data["models"] = models?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  Data copyWith({
    List<Models>? models,
  }) => Data(
    models: models ?? this.models,
  );
}

class Models {
  int? id;
  String? name;

  Models({this.id, this.name});

  Models.fromJson(Map<String, dynamic> json) {
    if(json["id"] is num) {
      id = (json["id"] as num).toInt();
    }
    if(json["name"] is String) {
      name = json["name"];
    }
  }

  static List<Models> fromList(List<Map<String, dynamic>> list) {
    return list.map(Models.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }

  Models copyWith({
    int? id,
    String? name,
  }) => Models(
    id: id ?? this.id,
    name: name ?? this.name,
  );
}