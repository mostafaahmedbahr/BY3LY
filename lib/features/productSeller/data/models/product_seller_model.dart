// Safe parsing helpers: the API sends the same field as `int`, `String`,
// `bool` or `null` depending on the endpoint, so every value is normalised
// before it reaches a strongly typed field.
int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString().trim());
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString().trim());
}

String? _toStr(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

bool? _toBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value.toString().trim().toLowerCase();
  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;
  return null;
}

class ProductSellerModel {
  bool? status;
  String? message;
  Data? data;

  ProductSellerModel({this.status, this.message, this.data});

  ProductSellerModel.fromJson(Map<String, dynamic> json) {
    status = _toBool(json["status"]);
    message = _toStr(json["message"]);
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  Seller? seller;
  List<Products>? products;
  Pagination? pagination;

  Data({this.seller, this.products, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    seller = json["seller"] == null ? null : Seller.fromJson(json["seller"]);
    products = json["products"] == null
        ? null
        : (json["products"] as List).map((e) => Products.fromJson(e)).toList();
    pagination = json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (seller != null) {
      _data["seller"] = seller?.toJson();
    }
    if (products != null) {
      _data["products"] = products?.map((e) => e.toJson()).toList();
    }
    if (pagination != null) {
      _data["pagination"] = pagination?.toJson();
    }
    return _data;
  }
}

class Pagination {
  int? total;
  int? perPage;
  int? currentPage;
  int? totalPages;

  Pagination({this.total, this.perPage, this.currentPage, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = _toInt(json["total"]);
    perPage = _toInt(json["per_page"]);
    currentPage = _toInt(json["current_page"]);
    totalPages = _toInt(json["total_pages"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["total"] = total;
    _data["per_page"] = perPage;
    _data["current_page"] = currentPage;
    _data["total_pages"] = totalPages;
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
  bool? isPaused;
  int? status;
  dynamic paymentMethod;
  dynamic paymentStatus;
  dynamic publicationFee;
  dynamic transferReference;
  dynamic receiptUrl;
  String? price;
  dynamic oldPrice;
  String? currency;
  dynamic shippingType;
  dynamic shippingTypeLabel;
  dynamic condition;
  dynamic conditionLabel;
  String? listingType;
  String? listingTypeLabel;
  dynamic furnishing;
  dynamic furnishingLabel;
  Seller1? seller;
  String? image;
  String? location;
  int? cityId;
  int? centerId;
  int? categoryId;
  String? categoryType;
  int? subCategoryId;
  String? subCategory;
  String? date;
  List<Images>? images;
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

  Products({
    this.id,
    this.name,
    this.desc,
    this.description,
    this.discount,
    this.finalPrice,
    this.isNegotiable,
    this.isUrgent,
    this.isPaused,
    this.status,
    this.paymentMethod,
    this.paymentStatus,
    this.publicationFee,
    this.transferReference,
    this.receiptUrl,
    this.price,
    this.oldPrice,
    this.currency,
    this.shippingType,
    this.shippingTypeLabel,
    this.condition,
    this.conditionLabel,
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
    this.views,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = _toInt(json["id"]);
    name = _toStr(json["name"]);
    desc = _toStr(json["desc"]);
    description = _toStr(json["description"]);
    discount = _toInt(json["discount"]);
    finalPrice = _toInt(json["final_price"]);
    isNegotiable = _toBool(json["is_negotiable"]);
    isUrgent = _toBool(json["is_urgent"]);
    isPaused = _toBool(json["is_paused"]);
    status = _toInt(json["status"]);
    paymentMethod = json["payment_method"];
    paymentStatus = json["payment_status"];
    publicationFee = json["publication_fee"];
    transferReference = json["transfer_reference"];
    receiptUrl = json["receipt_url"];
    price = _toStr(json["price"]);
    oldPrice = json["old_price"];
    currency = _toStr(json["currency"]);
    shippingType = json["shipping_type"];
    shippingTypeLabel = json["shipping_type_label"];
    condition = json["condition"];
    conditionLabel = json["condition_label"];
    listingType = _toStr(json["listing_type"]);
    listingTypeLabel = _toStr(json["listing_type_label"]);
    furnishing = json["furnishing"];
    furnishingLabel = json["furnishing_label"];
    seller = json["seller"] == null ? null : Seller1.fromJson(json["seller"]);
    image = _toStr(json["image"]);
    location = _toStr(json["location"]);
    cityId = _toInt(json["city_id"]);
    centerId = _toInt(json["center_id"]);
    categoryId = _toInt(json["category_id"]);
    categoryType = _toStr(json["category_type"]);
    subCategoryId = _toInt(json["sub_category_id"]);
    subCategory = _toStr(json["sub_category"]);
    date = _toStr(json["date"]);
    images = json["images"] == null
        ? null
        : (json["images"] as List).map((e) => Images.fromJson(e)).toList();
    rate = _toStr(json["rate"]);
    countCommenets = _toInt(json["countCommenets"]);
    commenets = json["commenets"] ?? [];
    reviews = json["reviews"] ?? [];
    reviewsCount = _toInt(json["reviews_count"]);
    isFavourite = _toBool(json["isFavourite"]);
    model = _toStr(json["model"]);
    marka = _toStr(json["marka"]);
    type = _toStr(json["type"]);
    createdAt = _toStr(json["created_at"]);
    views = _toInt(json["views"]);
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
    _data["is_paused"] = isPaused;
    _data["status"] = status;
    _data["payment_method"] = paymentMethod;
    _data["payment_status"] = paymentStatus;
    _data["publication_fee"] = publicationFee;
    _data["transfer_reference"] = transferReference;
    _data["receipt_url"] = receiptUrl;
    _data["price"] = price;
    _data["old_price"] = oldPrice;
    _data["currency"] = currency;
    _data["shipping_type"] = shippingType;
    _data["shipping_type_label"] = shippingTypeLabel;
    _data["condition"] = condition;
    _data["condition_label"] = conditionLabel;
    _data["listing_type"] = listingType;
    _data["listing_type_label"] = listingTypeLabel;
    _data["furnishing"] = furnishing;
    _data["furnishing_label"] = furnishingLabel;
    if (seller != null) {
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
    if (images != null) {
      _data["images"] = images?.map((e) => e.toJson()).toList();
    }
    _data["rate"] = rate;
    _data["countCommenets"] = countCommenets;
    if (commenets != null) {
      _data["commenets"] = commenets;
    }
    if (reviews != null) {
      _data["reviews"] = reviews;
    }
    _data["reviews_count"] = reviewsCount;
    _data["isFavourite"] = isFavourite;
    _data["model"] = model;
    _data["marka"] = marka;
    _data["type"] = type;
    _data["created_at"] = createdAt;
    _data["views"] = views;
    return _data;
  }
}

class Images {
  int? id;
  String? image;

  Images({this.id, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = _toInt(json["id"]);
    image = _toStr(json["image"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["image"] = image;
    return _data;
  }
}

class Seller1 {
  int? id;
  String? name;
  String? image;
  String? phone;
  String? contactMethod;
  bool? canChat;
  bool? canCall;
  String? storeName;
  double? rating;
  int? reviewsCount;

  Seller1({
    this.id,
    this.name,
    this.image,
    this.phone,
    this.contactMethod,
    this.canChat,
    this.canCall,
    this.storeName,
    this.rating,
    this.reviewsCount,
  });

  Seller1.fromJson(Map<String, dynamic> json) {
    id = _toInt(json["id"]);
    name = _toStr(json["name"]);
    image = _toStr(json["image"]);
    phone = _toStr(json["phone"]);
    contactMethod = _toStr(json["contact_method"]);
    canChat = _toBool(json["can_chat"]);
    canCall = _toBool(json["can_call"]);
    storeName = _toStr(json["store_name"]);
    rating = _toDouble(json["rating"]);
    reviewsCount = _toInt(json["reviews_count"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["image"] = image;
    _data["phone"] = phone;
    _data["contact_method"] = contactMethod;
    _data["can_chat"] = canChat;
    _data["can_call"] = canCall;
    _data["store_name"] = storeName;
    _data["rating"] = rating;
    _data["reviews_count"] = reviewsCount;
    return _data;
  }
}

class Seller {
  int? id;
  String? name;
  String? phone;
  String? contactMethod;
  bool? canChat;
  bool? canCall;
  String? storeName;
  String? image;
  double? rating;
  int? reviewsCount;
  int? productsCount;

  Seller({
    this.id,
    this.name,
    this.phone,
    this.contactMethod,
    this.canChat,
    this.canCall,
    this.storeName,
    this.image,
    this.rating,
    this.reviewsCount,
    this.productsCount,
  });

  Seller.fromJson(Map<String, dynamic> json) {
    id = _toInt(json["id"]);
    name = _toStr(json["name"]);
    phone = _toStr(json["phone"]);
    contactMethod = _toStr(json["contact_method"]);
    canChat = _toBool(json["can_chat"]);
    canCall = _toBool(json["can_call"]);
    storeName = _toStr(json["store_name"]);
    image = _toStr(json["image"]);
    rating = _toDouble(json["rating"]);
    reviewsCount = _toInt(json["reviews_count"]);
    productsCount = _toInt(json["products_count"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["phone"] = phone;
    _data["contact_method"] = contactMethod;
    _data["can_chat"] = canChat;
    _data["can_call"] = canCall;
    _data["store_name"] = storeName;
    _data["image"] = image;
    _data["rating"] = rating;
    _data["reviews_count"] = reviewsCount;
    _data["products_count"] = productsCount;
    return _data;
  }
}
