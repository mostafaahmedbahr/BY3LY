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

/// Maps a raw list into model objects, skipping junk entries silently —
/// a single malformed entry must never take the whole home response down.
List<T>? _parseList<T>(dynamic raw, T Function(Map<String, dynamic>) fromJson) {
  if (raw is! List) return null;
  final out = <T>[];
  for (final e in raw) {
    if (e is Map) out.add(fromJson(Map<String, dynamic>.from(e)));
  }
  return out;
}

/// Same as [_parseList] for product images, which may arrive as a mix of
/// plain URL strings and `{id, image}` objects.
List<Images>? _parseImages(dynamic raw) {
  if (raw is! List) return null;
  final out = <Images>[];
  for (final e in raw) {
    if (e is Map) {
      out.add(Images.fromJson(Map<String, dynamic>.from(e)));
    } else if (e is String && e.trim().isNotEmpty) {
      out.add(Images(image: e.trim()));
    }
  }
  return out;
}

class HomeModel {
  bool? status;
  String? message;
  HomeDataModel? data;

  HomeModel({this.status, this.message, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    final rawData = json["data"];
    data = rawData is Map ? HomeDataModel.fromJson(Map<String, dynamic>.from(rawData)) : null;
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

class HomeDataModel {
  List<Categories>? categories;
  List<BestView>? bestView;
  List<Ads>? ads;

  HomeDataModel({this.categories, this.bestView, this.ads});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    categories = _parseList(json["categories"], Categories.fromJson);
    bestView = _parseList(json["bestView"], BestView.fromJson);
    ads = _parseList(json["ads"], Ads.fromJson);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    if (categories != null) {
      jsonData["categories"] = categories?.map((e) => e.toJson()).toList();
    }
    if (bestView != null) {
      jsonData["bestView"] = bestView?.map((e) => e.toJson()).toList();
    }
    if (ads != null) {
      jsonData["ads"] = ads?.map((e) => e.toJson()).toList();
    }
    return jsonData;
  }
}

class Ads {
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
  Seller1? seller;
  String? image;
  dynamic location;
  dynamic cityId;
  int? categoryId;
  String? categoryType;
  int? subCategoryId;
  String? subCategory;
  String? date;
  List<Images>? images;
  int? rate;
  int? countCommenets;
  List<Commenets>? commenets;
  List<Reviews>? reviews;
  int? reviewsCount;
  bool? isFavourite;
  String? model;
  String? marka;
  String? type;
  String? createdAt;
  int? views;

  Ads({
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

  Ads.fromJson(Map<String, dynamic> json) {
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
    seller = json["seller"] is Map
        ? Seller1.fromJson(Map<String, dynamic>.from(json["seller"] as Map))
        : null;
    image = _asString(json["image"]);
    location = json["location"];
    cityId = json["city_id"];
    categoryId = _asInt(json["category_id"]);
    categoryType = _asString(json["category_type"]);
    subCategoryId = _asInt(json["sub_category_id"]);
    subCategory = _asString(json["sub_category"]);
    date = _asString(json["date"]);
    images = _parseImages(json["images"]);
    rate = _asInt(json["rate"]);
    countCommenets = _asInt(json["countCommenets"]);
    commenets = _parseList(json["commenets"], Commenets.fromJson);
    reviews = _parseList(json["reviews"], Reviews.fromJson);
    reviewsCount = _asInt(json["reviews_count"]);
    isFavourite = _asBool(json["isFavourite"]);
    model = _asString(json["model"]);
    marka = _asString(json["marka"]);
    type = _asString(json["type"]);
    createdAt = _asString(json["created_at"]);
    views = _asInt(json["views"]);
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
      jsonData["commenets"] = commenets?.map((e) => e.toJson()).toList();
    }
    if (reviews != null) {
      jsonData["reviews"] = reviews?.map((e) => e.toJson()).toList();
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

class Reviews {
  int? id;
  int? rate;
  String? commenet;
  String? user;
  int? userId;
  String? userImage;
  String? createdAt;
  String? timeAgo;

  Reviews({
    this.id,
    this.rate,
    this.commenet,
    this.user,
    this.userId,
    this.userImage,
    this.createdAt,
    this.timeAgo,
  });

  Reviews.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    rate = _asInt(json["rate"]);
    commenet = _asString(json["commenet"]);
    user = _asString(json["user"]);
    userId = _asInt(json["user_id"]);
    userImage = _asString(json["user_image"]);
    createdAt = _asString(json["created_at"]);
    timeAgo = _asString(json["time_ago"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["rate"] = rate;
    jsonData["commenet"] = commenet;
    jsonData["user"] = user;
    jsonData["user_id"] = userId;
    jsonData["user_image"] = userImage;
    jsonData["created_at"] = createdAt;
    jsonData["time_ago"] = timeAgo;
    return jsonData;
  }
}

class Commenets {
  int? id;
  int? rate;
  String? commenet;
  String? user;
  int? userId;
  String? userImage;
  String? createdAt;
  String? timeAgo;

  Commenets({
    this.id,
    this.rate,
    this.commenet,
    this.user,
    this.userId,
    this.userImage,
    this.createdAt,
    this.timeAgo,
  });

  Commenets.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    rate = _asInt(json["rate"]);
    commenet = _asString(json["commenet"]);
    user = _asString(json["user"]);
    userId = _asInt(json["user_id"]);
    userImage = _asString(json["user_image"]);
    createdAt = _asString(json["created_at"]);
    timeAgo = _asString(json["time_ago"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["rate"] = rate;
    jsonData["commenet"] = commenet;
    jsonData["user"] = user;
    jsonData["user_id"] = userId;
    jsonData["user_image"] = userImage;
    jsonData["created_at"] = createdAt;
    jsonData["time_ago"] = timeAgo;
    return jsonData;
  }
}

class Images {
  int? id;
  String? image;

  Images({this.id, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    image = _asString(json["image"]);
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
  int? rating;
  int? reviewsCount;

  Seller1({
    this.id,
    this.name,
    this.image,
    this.phone,
    this.rating,
    this.reviewsCount,
  });

  Seller1.fromJson(Map<String, dynamic> json) {
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

class BestView {
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

  BestView({
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

  BestView.fromJson(Map<String, dynamic> json) {
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
    seller = json["seller"] is Map
        ? Seller.fromJson(Map<String, dynamic>.from(json["seller"] as Map))
        : null;
    image = _asString(json["image"]);
    location = json["location"];
    cityId = json["city_id"];
    categoryId = _asInt(json["category_id"]);
    categoryType = _asString(json["category_type"]);
    subCategoryId = _asInt(json["sub_category_id"]);
    subCategory = _asString(json["sub_category"]);
    date = _asString(json["date"]);
    images = json["images"] is List ? (json["images"] as List) : const [];
    rate = _asString(json["rate"]);
    countCommenets = _asInt(json["countCommenets"]);
    commenets = json["commenets"] is List ? (json["commenets"] as List) : const [];
    reviews = json["reviews"] is List ? (json["reviews"] as List) : const [];
    reviewsCount = _asInt(json["reviews_count"]);
    isFavourite = _asBool(json["isFavourite"]);
    model = _asString(json["model"]);
    marka = _asString(json["marka"]);
    type = _asString(json["type"]);
    createdAt = _asString(json["created_at"]);
    views = _asInt(json["views"]);
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

class Categories {
  int? id;
  String? name;
  String? image;

  Categories({this.id, this.name, this.image});

  Categories.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    name = _asString(json["name"]);
    image = _asString(json["image"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["name"] = name;
    jsonData["image"] = image;
    return jsonData;
  }
}
