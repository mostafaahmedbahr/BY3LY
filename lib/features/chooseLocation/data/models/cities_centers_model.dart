
class AllCitiesAndCentersModel {
  bool? status;
  String? message;
  Data? data;

  AllCitiesAndCentersModel({this.status, this.message, this.data});

  AllCitiesAndCentersModel.fromJson(Map<String, dynamic> json) {
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
  List<Cities>? cities;

  Data({this.cities});

  Data.fromJson(Map<String, dynamic> json) {
    cities = json["cities"] == null ? null : (json["cities"] as List).map((e) => Cities.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(cities != null) {
      _data["cities"] = cities?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Cities {
  int? id;
  String? name;
  List<Centers>? centers;

  Cities({this.id, this.name, this.centers});

  Cities.fromJson(Map<String, dynamic> json) {
    id = (json["id"] as num).toInt();
    name = json["name"];
    centers = json["centers"] == null ? null : (json["centers"] as List).map((e) => Centers.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    if(centers != null) {
      _data["centers"] = centers?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Centers {
  int? id;
  String? name;

  Centers({this.id, this.name});

  Centers.fromJson(Map<String, dynamic> json) {
    id = (json["id"] as num).toInt();
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}