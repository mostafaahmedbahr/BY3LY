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

class ProductSellerModel {
  bool? status;
  String? message;
  Data? data;

  ProductSellerModel({this.status, this.message, this.data});

  ProductSellerModel.fromJson(Map<String, dynamic> json) {
    status = _toBool(json["status"]);
    message = _toStr(json["message"]);
    final raw = json["data"];
    if (raw is Map<String, dynamic>) {
      data = Data.fromJson(raw);
    } else {
      data = null;
    }
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
  Seller? seller;
  List<Products>? products;
  Pagination? pagination;

  Data({this.seller, this.products, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    final rawSeller = json["seller"];
    seller = rawSeller is Map
        ? Seller.fromJson(Map<String, dynamic>.from(rawSeller))
        : null;
    products = _parseList(json["products"], Products.fromJson);
    final rawPagination = json["pagination"];
    pagination = rawPagination is Map
        ? Pagination.fromJson(Map<String, dynamic>.from(rawPagination))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    if (seller != null) {
      jsonData["seller"] = seller?.toJson();
    }
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["total"] = total;
    jsonData["per_page"] = perPage;
    jsonData["current_page"] = currentPage;
    jsonData["total_pages"] = totalPages;
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
    final rawSeller = json["seller"];
    seller = rawSeller is Map
        ? Seller1.fromJson(Map<String, dynamic>.from(rawSeller))
        : null;
    image = _toStr(json["image"]);
    location = _toStr(json["location"]);
    cityId = _toInt(json["city_id"]);
    centerId = _toInt(json["center_id"]);
    categoryId = _toInt(json["category_id"]);
    categoryType = _toStr(json["category_type"]);
    subCategoryId = _toInt(json["sub_category_id"]);
    subCategory = _toStr(json["sub_category"]);
    date = _toStr(json["date"]);
    images = _parseList(json["images"], Images.fromJson);
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["name"] = name;
    jsonData["desc"] = desc;
    jsonData["description"] = description;
    jsonData["discount"] = discount;
    jsonData["final_price"] = finalPrice;
    jsonData["is_negotiable"] = isNegotiable;
    jsonData["is_urgent"] = isUrgent;
    jsonData["is_paused"] = isPaused;
    jsonData["status"] = status;
    jsonData["payment_method"] = paymentMethod;
    jsonData["payment_status"] = paymentStatus;
    jsonData["publication_fee"] = publicationFee;
    jsonData["transfer_reference"] = transferReference;
    jsonData["receipt_url"] = receiptUrl;
    jsonData["price"] = price;
    jsonData["old_price"] = oldPrice;
    jsonData["currency"] = currency;
    jsonData["shipping_type"] = shippingType;
    jsonData["shipping_type_label"] = shippingTypeLabel;
    jsonData["condition"] = condition;
    jsonData["condition_label"] = conditionLabel;
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
      jsonData["images"] = images?.map((e) => e.toJson()).toList();
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
    return jsonData;
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["image"] = image;
    return jsonData;
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["name"] = name;
    jsonData["image"] = image;
    jsonData["phone"] = phone;
    jsonData["contact_method"] = contactMethod;
    jsonData["can_chat"] = canChat;
    jsonData["can_call"] = canCall;
    jsonData["store_name"] = storeName;
    jsonData["rating"] = rating;
    jsonData["reviews_count"] = reviewsCount;
    return jsonData;
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["name"] = name;
    jsonData["phone"] = phone;
    jsonData["contact_method"] = contactMethod;
    jsonData["can_chat"] = canChat;
    jsonData["can_call"] = canCall;
    jsonData["store_name"] = storeName;
    jsonData["image"] = image;
    jsonData["rating"] = rating;
    jsonData["reviews_count"] = reviewsCount;
    jsonData["products_count"] = productsCount;
    return jsonData;
  }
}
