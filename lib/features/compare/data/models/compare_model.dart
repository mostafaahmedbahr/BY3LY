
String? _asString(dynamic v) => v?.toString();

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  if (v is bool) return v ? 1 : 0;
  return null;
}

bool? _asBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is int) return v != 0;
  if (v is String) {
    final lower = v.toLowerCase();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}

class CompareModel {
  bool? status;
  String? message;
  CompareData? data;

  CompareModel({this.status, this.message, this.data});

  CompareModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]) ?? json["status"] == 1;
    message = _asString(json["message"]);
    final rawData = json["data"];
    if (rawData is Map<String, dynamic>) {
      data = CompareData.fromJson(rawData);
    } else if (rawData is List) {
      // Some backends return the products list directly in "data".
      data = CompareData(products: rawData.map((e) => CompareProduct.fromJson(e)).toList());
    }
  }
}

class CompareData {
  List<CompareProduct>? products;

  CompareData({this.products});

  CompareData.fromJson(Map<String, dynamic> json) {
    products = json["products"] == null
        ? null
        : (json["products"] as List)
            .map((e) => CompareProduct.fromJson(e))
            .toList();
  }
}

class CompareProduct {
  int? id;
  String? name;
  String? desc;
  String? price;
  String? oldPrice;
  String? currency;
  String? image;
  List<dynamic>? images;
  String? rate;
  int? reviewsCount;
  String? type;
  String? model;
  String? marka;
  String? location;
  String? date;
  String? createdAt;

  CompareProduct({
    this.id,
    this.name,
    this.desc,
    this.price,
    this.oldPrice,
    this.currency,
    this.image,
    this.images,
    this.rate,
    this.reviewsCount,
    this.type,
    this.model,
    this.marka,
    this.location,
    this.date,
    this.createdAt,
  });

  CompareProduct.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    name = _asString(json["name"]);
    desc = _asString(json["desc"]) ?? _asString(json["description"]);
    price = _asString(json["price"]) ?? _asString(json["final_price"]);
    oldPrice = _asString(json["old_price"]);
    currency = _asString(json["currency"]);
    image = _asString(json["image"]);
    images = json["images"] ?? [];
    rate = _asString(json["rate"]);
    reviewsCount = _asInt(json["reviews_count"]);
    type = _asString(json["type"]) ?? _asString(json["listing_type_label"]);
    model = _asString(json["model"]);
    marka = _asString(json["marka"]);
    location = _asString(json["location"]);
    date = _asString(json["date"]);
    createdAt = _asString(json["created_at"]);
  }
}
