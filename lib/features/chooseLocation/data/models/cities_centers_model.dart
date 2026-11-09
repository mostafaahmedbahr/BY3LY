
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["status"] = status;
    jsonData["message"] = message;
    if(data != null) {
      jsonData["data"] = data?.toJson();
    }
    return jsonData;
  }
}

class Data {
  List<Cities>? cities;

  Data({this.cities});

  Data.fromJson(Map<String, dynamic> json) {
    cities = json["cities"] == null ? null : (json["cities"] as List).map((e) => Cities.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    if(cities != null) {
      jsonData["cities"] = cities?.map((e) => e.toJson()).toList();
    }
    return jsonData;
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["name"] = name;
    if(centers != null) {
      jsonData["centers"] = centers?.map((e) => e.toJson()).toList();
    }
    return jsonData;
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["name"] = name;
    return jsonData;
  }
}