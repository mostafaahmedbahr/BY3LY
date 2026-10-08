
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

class AllProductsSearchModel {
  bool? status;
  String? message;
  Data? data;

  AllProductsSearchModel({this.status, this.message, this.data});

  AllProductsSearchModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]) ?? json["status"] == 1;
    message = _asString(json["message"]);
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
  List<Products>? products;
  Pagination? pagination;

  Data({this.products, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    products = json["products"] == null ? null : (json["products"] as List).map((e) => Products.fromJson(e)).toList();
    pagination = json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(products != null) {
      _data["products"] = products?.map((e) => e.toJson()).toList();
    }
    if(pagination != null) {
      _data["pagination"] = pagination?.toJson();
    }
    return _data;
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["current_page"] = currentPage;
    _data["last_page"] = lastPage;
    _data["per_page"] = perPage;
    _data["total"] = total;
    return _data;
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
  String? shippingType;
  String? condition;

  Products({this.id, this.name, this.desc, this.description, this.discount, this.finalPrice, this.isNegotiable, this.isUrgent, this.price, this.oldPrice, this.currency, this.listingType, this.listingTypeLabel, this.furnishing, this.furnishingLabel, this.seller, this.image, this.location, this.cityId, this.centerId, this.categoryId, this.categoryType, this.subCategoryId, this.subCategory, this.date, this.images, this.rate, this.countCommenets, this.commenets, this.reviews, this.reviewsCount, this.isFavourite, this.model, this.marka, this.type, this.createdAt, this.shippingType, this.condition});

  Products.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    name = _asString(json["name"]);
    desc = _asString(json["desc"]);
    description = _asString(json["description"]);
    discount = _asInt(json["discount"]);
    finalPrice = _asInt(json["final_price"]);
    isNegotiable = _asBool(json["is_negotiable"]);
    isUrgent = _asBool(json["is_urgent"]);
    price = _asString(json["price"]);
    oldPrice = json["old_price"];
    currency = _asString(json["currency"]);
    listingType = _asString(json["listing_type"]);
    listingTypeLabel = _asString(json["listing_type_label"]);
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["desc"] = desc;
    _data["description"] = description;
    _data["discount"] = discount;
    _data["final_price"] = finalPrice;
    _data["is_negotiable"] = isNegotiable;
    _data["is_urgent"] = isUrgent;
    _data["price"] = price;
    _data["old_price"] = oldPrice;
    _data["currency"] = currency;
    _data["listing_type"] = listingType;
    _data["listing_type_label"] = listingTypeLabel;
    _data["furnishing"] = furnishing;
    _data["furnishing_label"] = furnishingLabel;
    if(seller != null) {
      _data["seller"] = seller?.toJson();
    }
    _data["image"] = image;
    _data["location"] = location;
    _data["city_id"] = cityId;
    _data["center_id"] = centerId;
    _data["category_id"] = categoryId;
    _data["category_type"] = categoryType;
    _data["sub_category_id"] = subCategoryId;
    _data["sub_category"] = subCategory;
    _data["date"] = date;
    if(images != null) {
      _data["images"] = images;
    }
    _data["rate"] = rate;
    _data["countCommenets"] = countCommenets;
    if(commenets != null) {
      _data["commenets"] = commenets;
    }
    if(reviews != null) {
      _data["reviews"] = reviews;
    }
    _data["reviews_count"] = reviewsCount;
    _data["isFavourite"] = isFavourite;
    _data["model"] = model;
    _data["marka"] = marka;
    _data["type"] = type;
    _data["created_at"] = createdAt;
    _data["shipping_type"] = shippingType;
    _data["condition"] = condition;
    return _data;
  }
}

class Seller {
  int? id;
  String? name;
  String? image;
  String? phone;
  int? rating;
  int? reviewsCount;

  Seller({this.id, this.name, this.image, this.phone, this.rating, this.reviewsCount});

  Seller.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    name = _asString(json["name"]);
    image = _asString(json["image"]);
    phone = _asString(json["phone"]);
    rating = _asInt(json["rating"]);
    reviewsCount = _asInt(json["reviews_count"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["image"] = image;
    _data["phone"] = phone;
    _data["rating"] = rating;
    _data["reviews_count"] = reviewsCount;
    return _data;
  }
}