String? _asString(dynamic v) => v?.toString();

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  if (v is bool) return v ? 1 : 0;
  return null;
}

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v);
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

class AllSubCategoriesProductsModel {
  bool? status;
  String? message;
  Data? data;

  AllSubCategoriesProductsModel({this.status, this.message, this.data});

  AllSubCategoriesProductsModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]) ?? json["status"] == 1;
    message = _asString(json["message"]);
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["status"] = status;
    jsonData["message"] = message;
    if (data != null) {
      jsonData["data"] = data?.toJson();
    }
    return jsonData;
  }
}

class Data {
  List<Products>? products;

  Data({this.products});

  Data.fromJson(Map<String, dynamic> json) {
    products = json["products"] == null
        ? null
        : (json["products"] as List).map((e) => Products.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    if (products != null) {
      jsonData["products"] = products?.map((e) => e.toJson()).toList();
    }
    return jsonData;
  }
}

class Products {
  int? id;
  String? name;
  String? desc;
  dynamic price;
  dynamic oldPrice;
  String? currency;
  dynamic listingType;
  dynamic listingTypeLabel;
  dynamic furnishing;
  dynamic furnishingLabel;
  Seller? seller;
  String? image;
  dynamic location;
  dynamic cityId;
  dynamic centerId;
  int? categoryId;
  String? categoryType;
  int? subCategoryId;
  String? subCategory;
  String? date;
  List<dynamic>? images;
  String? rate;
  int? countCommenets;
  List<dynamic>? commenets;
  List<dynamic>? reviews;
  int? reviewsCount;
  bool? isFavourite;
  String? model;
  String? marka;
  String? type;
  String? createdAt;
  String? shippingType;
  String? condition;
  bool? isUrgent;
  int? status;
  int? views;

  Products({
    this.id,
    this.name,
    this.desc,
    this.price,
    this.oldPrice,
    this.currency,
    this.listingType,
    this.listingTypeLabel,
    this.furnishing,
    this.furnishingLabel,
    this.seller,
    this.image,
    this.location,
    this.cityId,
    this.centerId,
    this.categoryId,
    this.categoryType,
    this.subCategoryId,
    this.subCategory,
    this.date,
    this.images,
    this.rate,
    this.countCommenets,
    this.commenets,
    this.reviews,
    this.reviewsCount,
    this.isFavourite,
    this.model,
    this.marka,
    this.type,
    this.createdAt,
    this.shippingType,
    this.condition,
    this.isUrgent,
    this.status,
    this.views,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    name = _asString(json["name"]);
    desc = _asString(json["desc"]);
    price = json["price"]?.toString();

    oldPrice = json["old_price"];

    currency = _asString(json["currency"]);

    listingType = json["listing_type"];
    listingTypeLabel = json["listing_type_label"];

    furnishing = json["furnishing"];
    furnishingLabel = json["furnishing_label"];

    seller = json["seller"] == null ? null : Seller.fromJson(json["seller"]);

    image = _asString(json["image"]);

    location = json["location"];
    cityId = json["city_id"];
    centerId = json["center_id"];

    categoryId = _asInt(json["category_id"]);

    categoryType = _asString(json["category_type"]);

    subCategoryId = _asInt(json["sub_category_id"]);

    subCategory = _asString(json["sub_category"]);

    date = _asString(json["date"]);

    images = json["images"] ?? [];

    // مهم جدًا
    rate = _asString(json["rate"]);

    countCommenets = _asInt(json["countCommenets"]);

    commenets = json["commenets"] ?? [];

    reviews = json["reviews"] ?? [];

    reviewsCount = _asInt(json["reviews_count"]);

    isFavourite = _asBool(json["isFavourite"]);

    model = _asString(json["model"]);

    marka = _asString(json["marka"]);

    type = _asString(json["type"]);

    createdAt = _asString(json["created_at"]);

    shippingType = _asString(json["shipping_type"]);

    condition = _asString(json["condition"]);

    isUrgent = _asBool(json["is_urgent"]);

    status = _asInt(json["status"]);

    views = _asInt(json["views"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["name"] = name;
    jsonData["desc"] = desc;
    jsonData["price"] = price;
    jsonData["old_price"] = oldPrice;
    jsonData["currency"] = currency;
    jsonData["listing_type"] = listingType;
    jsonData["listing_type_label"] = listingTypeLabel;
    jsonData["furnishing"] = furnishing;
    jsonData["furnishing_label"] = furnishingLabel;
    if (seller != null) {
      jsonData["seller"] = seller?.toJson();
    }
    jsonData["image"] = image;
    jsonData["location"] = location;
    jsonData["city_id"] = cityId;
    jsonData["center_id"] = centerId;
    jsonData["category_id"] = categoryId;
    jsonData["category_type"] = categoryType;
    jsonData["sub_category_id"] = subCategoryId;
    jsonData["sub_category"] = subCategory;
    jsonData["date"] = date;
    if (images != null) {
      jsonData["images"] = images;
    }
    jsonData["rate"] = rate;
    jsonData["countCommenets"] = countCommenets;
    if (commenets != null) {
      jsonData["commenets"] = commenets;
    }
    if (reviews != null) {
      jsonData["reviews"] = reviews;
    }
    jsonData["reviews_count"] = reviewsCount;
    jsonData["isFavourite"] = isFavourite;
    jsonData["model"] = model;
    jsonData["marka"] = marka;
    jsonData["type"] = type;
    jsonData["created_at"] = createdAt;
    jsonData["shipping_type"] = shippingType;
    jsonData["condition"] = condition;
    jsonData["is_urgent"] = isUrgent;
    jsonData["status"] = status;
    jsonData["views"] = views;
    return jsonData;
  }
}

class Seller {
  int? id;
  String? name;
  String? image;
  String? phone;
  double? rating;
  int? reviewsCount;

  Seller({
    this.id,
    this.name,
    this.image,
    this.phone,
    this.rating,
    this.reviewsCount,
  });

  Seller.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    name = _asString(json["name"]);
    image = _asString(json["image"]);
    phone = _asString(json["phone"]);
    rating = _asDouble(json["rating"]);
    reviewsCount = _asInt(json["reviews_count"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["name"] = name;
    jsonData["image"] = image;
    jsonData["phone"] = phone;
    jsonData["rating"] = rating;
    jsonData["reviews_count"] = reviewsCount;
    return jsonData;
  }
}
