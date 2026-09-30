
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

class HomeModel {
  bool? status;
  String? message;
  HomeDataModel? data;

  HomeModel({this.status, this.message, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]) ?? json["status"] == 1;
    message = _asString(json["message"]);
    data = json["data"] == null ? null : HomeDataModel.fromJson(json["data"]);
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

class HomeDataModel {
  List<Categories>? categories;
  List<BestView>? bestView;
  List<Ads>? ads;

  HomeDataModel({this.categories, this.bestView, this.ads});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    categories = json["categories"] == null ? null : (json["categories"] as List).map((e) => Categories.fromJson(e)).toList();
    bestView = json["bestView"] == null ? null : (json["bestView"] as List).map((e) => BestView.fromJson(e)).toList();
    ads = json["ads"] == null ? null : (json["ads"] as List).map((e) => Ads.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(categories != null) {
      _data["categories"] = categories?.map((e) => e.toJson()).toList();
    }
    if(bestView != null) {
      _data["bestView"] = bestView?.map((e) => e.toJson()).toList();
    }
    if(ads != null) {
      _data["ads"] = ads?.map((e) => e.toJson()).toList();
    }
    return _data;
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

  Ads({this.id, this.name, this.desc, this.description, this.discount, this.finalPrice, this.isNegotiable, this.isUrgent, this.price, this.oldPrice, this.currency, this.listingType, this.listingTypeLabel, this.furnishing, this.furnishingLabel, this.seller, this.image, this.location, this.cityId, this.categoryId, this.categoryType, this.subCategoryId, this.subCategory, this.date, this.images, this.rate, this.countCommenets, this.commenets, this.reviews, this.reviewsCount, this.isFavourite, this.model, this.marka, this.type, this.createdAt});

  Ads.fromJson(Map<String, dynamic> json) {
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
    seller = json["seller"] == null ? null : Seller1.fromJson(json["seller"]);
    image = _asString(json["image"]);
    location = json["location"];
    cityId = json["city_id"];
    categoryId = _asInt(json["category_id"]);
    categoryType = _asString(json["category_type"]);
    subCategoryId = _asInt(json["sub_category_id"]);
    subCategory = _asString(json["sub_category"]);
    date = _asString(json["date"]);
    images = json["images"] == null ? null : (json["images"] as List).map((e) => Images.fromJson(e)).toList();
    rate = _asInt(json["rate"]);
    countCommenets = _asInt(json["countCommenets"]);
    commenets = json["commenets"] == null ? null : (json["commenets"] as List).map((e) => Commenets.fromJson(e)).toList();
    reviews = json["reviews"] == null ? null : (json["reviews"] as List).map((e) => Reviews.fromJson(e)).toList();
    reviewsCount = _asInt(json["reviews_count"]);
    isFavourite = _asBool(json["isFavourite"]);
    model = _asString(json["model"]);
    marka = _asString(json["marka"]);
    type = _asString(json["type"]);
    createdAt = _asString(json["created_at"]);
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
    _data["category_id"] = categoryId;
    _data["category_type"] = categoryType;
    _data["sub_category_id"] = subCategoryId;
    _data["sub_category"] = subCategory;
    _data["date"] = date;
    if(images != null) {
      _data["images"] = images?.map((e) => e.toJson()).toList();
    }
    _data["rate"] = rate;
    _data["countCommenets"] = countCommenets;
    if(commenets != null) {
      _data["commenets"] = commenets?.map((e) => e.toJson()).toList();
    }
    if(reviews != null) {
      _data["reviews"] = reviews?.map((e) => e.toJson()).toList();
    }
    _data["reviews_count"] = reviewsCount;
    _data["isFavourite"] = isFavourite;
    _data["model"] = model;
    _data["marka"] = marka;
    _data["type"] = type;
    _data["created_at"] = createdAt;
    return _data;
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

  Reviews({this.id, this.rate, this.commenet, this.user, this.userId, this.userImage, this.createdAt, this.timeAgo});

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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["rate"] = rate;
    _data["commenet"] = commenet;
    _data["user"] = user;
    _data["user_id"] = userId;
    _data["user_image"] = userImage;
    _data["created_at"] = createdAt;
    _data["time_ago"] = timeAgo;
    return _data;
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

  Commenets({this.id, this.rate, this.commenet, this.user, this.userId, this.userImage, this.createdAt, this.timeAgo});

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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["rate"] = rate;
    _data["commenet"] = commenet;
    _data["user"] = user;
    _data["user_id"] = userId;
    _data["user_image"] = userImage;
    _data["created_at"] = createdAt;
    _data["time_ago"] = timeAgo;
    return _data;
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
  int? rating;
  int? reviewsCount;

  Seller1({this.id, this.name, this.image, this.phone, this.rating, this.reviewsCount});

  Seller1.fromJson(Map<String, dynamic> json) {
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

class BestView {
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

  BestView({this.id, this.name, this.desc, this.description, this.discount, this.finalPrice, this.isNegotiable, this.isUrgent, this.price, this.oldPrice, this.currency, this.listingType, this.listingTypeLabel, this.furnishing, this.furnishingLabel, this.seller, this.image, this.location, this.cityId, this.categoryId, this.categoryType, this.subCategoryId, this.subCategory, this.date, this.images, this.rate, this.countCommenets, this.commenets, this.reviews, this.reviewsCount, this.isFavourite, this.model, this.marka, this.type, this.createdAt});

  BestView.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["image"] = image;
    return _data;
  }
}