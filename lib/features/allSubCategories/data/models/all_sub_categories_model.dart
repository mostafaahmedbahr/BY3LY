
class AllSubCategoriesModel {
  bool? status;
  String? message;
  Data? data;

  AllSubCategoriesModel({this.status, this.message, this.data});

  AllSubCategoriesModel.fromJson(Map<String, dynamic> json) {
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
  List<SubCategories>? subCategories;

  Data({this.subCategories});

  Data.fromJson(Map<String, dynamic> json) {
    subCategories = json["subCategories"] == null ? null : (json["subCategories"] as List).map((e) => SubCategories.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(subCategories != null) {
      _data["subCategories"] = subCategories?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class SubCategories {
  int? id;
  String? name;
  String? image;
  int? productsCount;

  SubCategories({this.id, this.name, this.image, this.productsCount});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = (json["id"] as num).toInt();
    name = json["name"];
    image = json["image"];
    productsCount = (json["products_count"] as num).toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["image"] = image;
    _data["products_count"] = productsCount;
    return _data;
  }
}