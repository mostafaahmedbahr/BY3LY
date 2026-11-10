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
  if (v is num) return v != 0;
  if (v is String) {
    final lower = v.toString().trim().toLowerCase();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}

List<T>? _parseList<T>(
  dynamic raw,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (raw is! List) return null;
  final out = <T>[];
  for (final e in raw) {
    if (e is Map) out.add(fromJson(Map<String, dynamic>.from(e)));
  }
  return out;
}

class AllProductsSearchModel {
  bool? status;
  String? message;
  Data? data;

  AllProductsSearchModel({this.status, this.message, this.data});

  AllProductsSearchModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    final raw = json["data"];
    data = raw is Map ? Data.fromJson(Map<String, dynamic>.from(raw)) : null;
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
  Pagination? pagination;

  Data({this.products, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    products = _parseList(json["products"], Products.fromJson);
    final rawPagination = json["pagination"];
    pagination = rawPagination is Map
        ? Pagination.fromJson(Map<String, dynamic>.from(rawPagination))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    if (products != null) {
      jsonData["products"] = products?.map((e) => e.toJson()).toList();
    }
    if (pagination != null) {
      jsonData["pagination"] = pagination?.toJson();
    }
    return jsonData;
  }
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Pagination({this.currentPage, this.lastPage, this.perPage, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = _asInt(json["current_page"]);
    lastPage = _asInt(json["last_page"]);
    perPage = _asInt(json["per_page"]);
    total = _asInt(json["total"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["current_page"] = currentPage;
    jsonData["last_page"] = lastPage;
    jsonData["per_page"] = perPage;
    jsonData["total"] = total;
    return jsonData;
  }
}

class Products {
  int? id;
  String? name;
  String? desc;
  String? description;
  int? discount;
  int? finalPrice;
  bool? isNegotiable;
  bool? isUrgent;
  int? status;
  String? price;
  dynamic oldPrice;
  String? currency;
  String? listingType;
  String? listingTypeLabel;
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
  int? views;
  String? shippingType;
  String? condition;

  Products({
    this.id,
    this.name,
    this.desc,
    this.description,
    this.discount,
    this.finalPrice,
    this.isNegotiable,
    this.isUrgent,
    this.status,
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
    this.views,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    name = _asString(json["name"]);
    desc = _asString(json["desc"]);
    description = _asString(json["description"]);
    discount = _asInt(json["discount"]);
    finalPrice = _asInt(json["final_price"]);
    isNegotiable = _asBool(json["is_negotiable"]);
    isUrgent = _asBool(json["is_urgent"]);
    status = _asInt(json["status"]);
    price = _asString(json["price"]);
    oldPrice = json["old_price"];
    currency = _asString(json["currency"]);
    listingType = _asString(json["listing_type"]);
    listingTypeLabel = _asString(json["listing_type_label"]);
    furnishing = json["furnishing"];
    furnishingLabel = json["furnishing_label"];
    final rawSeller = json["seller"];
    seller = rawSeller is Map
        ? Seller.fromJson(Map<String, dynamic>.from(rawSeller))
        : null;
    image = _asString(json["image"]);
    location = json["location"];
    cityId = json["city_id"];
    centerId = json["center_id"];
    categoryId = _asInt(json["category_id"]);
    categoryType = _asString(json["category_type"]);
    subCategoryId = _asInt(json["sub_category_id"]);
    subCategory = _asString(json["sub_category"]);
    date = _asString(json["date"]);
    images = json["images"] is List ? json["images"] as List : null;
    rate = _asString(json["rate"]);
    countCommenets = _asInt(json["countCommenets"]);
    commenets = json["commenets"] is List ? json["commenets"] as List : null;
    reviews = json["reviews"] is List ? json["reviews"] as List : null;
    reviewsCount = _asInt(json["reviews_count"]);
    isFavourite = _asBool(json["isFavourite"]);
    model = _asString(json["model"]);
    marka = _asString(json["marka"]);
    type = _asString(json["type"]);
    createdAt = _asString(json["created_at"]);
    views = _asInt(json["views"]);
    shippingType = _asString(json["shipping_type"]);
    condition = _asString(json["condition"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["name"] = name;
    jsonData["desc"] = desc;
    jsonData["description"] = description;
    jsonData["discount"] = discount;
    jsonData["final_price"] = finalPrice;
    jsonData["is_negotiable"] = isNegotiable;
    jsonData["is_urgent"] = isUrgent;
    jsonData["status"] = status;
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
    jsonData["views"] = views;
    jsonData["shipping_type"] = shippingType;
    jsonData["condition"] = condition;
    return jsonData;
  }
}

class Seller {
  int? id;
  String? name;
  String? image;
  String? phone;
  int? rating;
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
    rating = _asInt(json["rating"]);
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
