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

/// GET getSubCategories?category_id={id} →
/// { status, message, data: { subCategories: [...] } }
///
/// Parsing is tolerant: the API may send numeric/boolean fields as
/// strings depending on the environment.
class AllSubCategoriesModel {
  bool? status;
  String? message;
  Data? data;

  AllSubCategoriesModel({this.status, this.message, this.data});

  AllSubCategoriesModel.fromJson(Map<String, dynamic> json) {
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
  List<SubCategories>? subCategories;

  Data({this.subCategories});

  Data.fromJson(Map<String, dynamic> json) {
    subCategories = json["subCategories"] == null
        ? null
        : (json["subCategories"] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => SubCategories.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
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
