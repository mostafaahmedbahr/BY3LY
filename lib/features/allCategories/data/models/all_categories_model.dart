int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is bool) return v ? 1 : 0;
  if (v is String) return int.tryParse(v.trim());
  return null;
}

String? _asString(dynamic v) => v?.toString();

bool? _asBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is int) return v != 0;
  if (v is String) {
    final lower = v.toLowerCase().trim();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}

/// GET viewAllCategories → { status, message, data: { categories: [...] } }
///
/// Parsing is tolerant: the API may send `products_count` / `id` / `status`
/// as strings or bools depending on the environment.
class AllCategoriesModel {
  bool? status;
  String? message;
  Data? data;

  AllCategoriesModel({this.status, this.message, this.data});

  AllCategoriesModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData["status"] = status;
    jsonData["message"] = message;
    if (data != null) {
      jsonData["data"] = data?.toJson();
    }
    return jsonData;
  }
}

class Data {
  List<Categories>? categories;

  Data({this.categories});

  Data.fromJson(Map<String, dynamic> json) {
    categories = json["categories"] == null
        ? null
        : (json["categories"] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => Categories.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    if (categories != null) {
      jsonData["categories"] = categories?.map((e) => e.toJson()).toList();
    }
    return jsonData;
  }
}

class Categories {
  int? id;
  String? name;
  String? image;
  List<SubCategories>? subCategories;

  Categories({this.id, this.name, this.image, this.subCategories});

  Categories.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    name = _asString(json["name"]);
    image = _asString(json["image"]);
    subCategories = json["subCategories"] == null
        ? null
        : (json["subCategories"] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => SubCategories.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["name"] = name;
    jsonData["image"] = image;
    if (subCategories != null) {
      jsonData["subCategories"] =
          subCategories?.map((e) => e.toJson()).toList();
    }
    return jsonData;
  }
}

class SubCategories {
  int? id;
  String? name;
  String? image;
  int? productsCount;

  SubCategories({this.id, this.name, this.image, this.productsCount});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    name = _asString(json["name"]);
    image = _asString(json["image"]);
    productsCount = _asInt(json["products_count"]);
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["name"] = name;
    jsonData["image"] = image;
    jsonData["products_count"] = productsCount;
    return jsonData;
  }
}
