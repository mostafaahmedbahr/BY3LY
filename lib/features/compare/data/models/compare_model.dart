String? _asString(dynamic v) => v?.toString();

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is bool) return v ? 1 : 0;
  if (v is String) return int.tryParse(v.trim());
  return null;
}

bool? _asBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final lower = v.toLowerCase().trim();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
  }
  return null;
}

/// The API returns { status, message, data: { products: [...] } }
/// `data` may also be a bare `List<CompareProduct>`, or contain a
/// `Data`-shaped object (Laravel convention with envelope).
class CompareModel {
  bool? status;
  String? message;
  CompareData? data;

  CompareModel({this.status, this.message, this.data});

  CompareModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json['status']) ?? json['status'] == 1;
    message = _asString(json['message']);
    final raw = json['data'];
    if (raw is List) {
      data = CompareData(products:
          raw.whereType<Map<String, dynamic>>().map(CompareProduct.fromJson).toList());
    } else if (raw is Map<String, dynamic>) {
      data = CompareData.fromJson(raw);
    } else {
      data = null;
    }
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData['status'] = status;
    jsonData['message'] = message;
    if (data != null) {
      jsonData['data'] = data!.toJson();
    }
    return jsonData;
  }
}

/// `products` may be a list of products (default) or wrapped under a
/// `products` key / `data` map; all variants are tolerated.
class CompareData {
  List<CompareProduct>? products;

  CompareData({this.products});

  CompareData.fromJson(Map<String, dynamic> json) {
    final raw = json['products'] ?? json['data'];
    if (raw is List) {
      products = raw.whereType<Map<String, dynamic>>().map(CompareProduct.fromJson).toList();
    } else if (raw is Map<String, dynamic>) {
      products = (raw['products'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(CompareProduct.fromJson)
          .toList();
    } else {
      products = null;
    }
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData['products'] =
        products == null ? const <Map<String, dynamic>>[] : products!.map((e) => e.toJson()).toList();
    return jsonData;
  }
}

/// A product in the compare payload. Tolerant of the same key variants the
/// rest of the app uses (`desc`/`description`, `price`/`final_price`,
/// `type`/`listing_type`/`listing_type_label`, `old_price` as num or string,
/// `images` as strings or objects...).
class CompareProduct {
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
  List<String> imageUrls = const <String>[];
  List<dynamic>? images;
  String? rate;
  int? countCommenets;
  List<dynamic>? commenets;
  List<dynamic>? reviews;
  int? reviewsCount;
  bool? isFavourite;
  int? views;
  String? type;
  String? model;
  String? marka;
  String? location;
  String? cityId;
  int? categoryId;
  String? categoryType;
  int? subCategoryId;
  String? subCategory;
  String? date;
  String? createdAt;

  CompareProduct({
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
    this.images,
    List<String>? imageUrls,
    this.rate,
    this.countCommenets,
    this.commenets,
    this.reviews,
    this.reviewsCount,
    this.isFavourite,
    this.views,
    this.type,
    this.model,
    this.marka,
    this.location,
    this.cityId,
    this.categoryId,
    this.categoryType,
    this.subCategoryId,
    this.subCategory,
    this.date,
    this.createdAt,
  }) : imageUrls = imageUrls ?? const <String>[];

  CompareProduct.fromJson(Map<String, dynamic> json) {
    id = _asInt(json['id']);
    name = _asString(json['name']);
    desc = _asString(json['desc']) ?? _asString(json['description']);
    description = _asString(json['description']);
    discount = _asInt(json['discount']);
    finalPrice = _asInt(json['final_price']);
    isNegotiable = _asBool(json['is_negotiable']);
    isUrgent = _asBool(json['is_urgent']);
    status = _asInt(json['status']);
    price = _asString(json['price']) ?? _asString(json['final_price']);
    oldPrice = _asString(json['old_price']) ?? _asString(json['oldPrice']);
    currency = _asString(json['currency']);
    listingType = _asString(json['listing_type']);
    listingTypeLabel =
        _asString(json['listing_type_label']) ?? _asString(json['listing_type']);
    furnishing = json['furnishing'];
    furnishingLabel = json['furnishing_label'];
    seller = json['seller'] is Map<String, dynamic>
        ? Seller.fromJson(json['seller'] as Map<String, dynamic>)
        : null;
    image = _asString(json['image']);
    final rawImages = json['images'];
    images = rawImages ?? const <dynamic>[];
    if (rawImages is List) {
      imageUrls = rawImages
          .map((e) {
            if (e is String) return e.trim();
            if (e is Map<String, dynamic>) return _asString(e['image'])?.trim() ?? '';
            return '';
          })
          .where((e) => e.isNotEmpty)
          .toList();
    } else {
      imageUrls = const <String>[];
    }
    rate = _asString(json['rate']);
    countCommenets = _asInt(json['countCommenets']);
    commenets = json['commenets'] ?? const <dynamic>[];
    reviews = json['reviews'] ?? const <dynamic>[];
    reviewsCount = _asInt(json['reviews_count']);
    isFavourite = _asBool(json['isFavourite']);
    views = _asInt(json['views']);
    type = _asString(json['type']) ??
        _asString(json['listing_type_label']) ??
        _asString(json['listing_type']);
    model = _asString(json['model']);
    marka = _asString(json['marka']);
    location = json['location']?.toString();
    cityId = json['city_id']?.toString();
    categoryId = _asInt(json['category_id']);
    categoryType = _asString(json['category_type']);
    subCategoryId = _asInt(json['sub_category_id']);
    subCategory = _asString(json['sub_category']);
    date = _asString(json['date']);
    createdAt = _asString(json['created_at']);
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData['id'] = id;
    jsonData['name'] = name;
    jsonData['desc'] = desc;
    jsonData['description'] = description;
    jsonData['discount'] = discount;
    jsonData['final_price'] = finalPrice;
    jsonData['is_negotiable'] = isNegotiable;
    jsonData['is_urgent'] = isUrgent;
    jsonData['status'] = status;
    jsonData['price'] = price;
    jsonData['old_price'] = oldPrice;
    jsonData['currency'] = currency;
    jsonData['listing_type'] = listingType;
    jsonData['listing_type_label'] = listingTypeLabel;
    jsonData['furnishing'] = furnishing;
    jsonData['furnishing_label'] = furnishingLabel;
    if (seller != null) jsonData['seller'] = seller!.toJson();
    jsonData['image'] = image;
    jsonData['images'] = imageUrls;
    jsonData['rate'] = rate;
    jsonData['countCommenets'] = countCommenets;
    jsonData['commenets'] = commenets;
    jsonData['reviews'] = reviews;
    jsonData['reviews_count'] = reviewsCount;
    jsonData['isFavourite'] = isFavourite;
    jsonData['views'] = views;
    jsonData['type'] = type;
    jsonData['model'] = model;
    jsonData['marka'] = marka;
    jsonData['location'] = location;
    jsonData['city_id'] = cityId;
    jsonData['category_id'] = categoryId;
    jsonData['category_type'] = categoryType;
    jsonData['sub_category_id'] = subCategoryId;
    jsonData['sub_category'] = subCategory;
    jsonData['date'] = date;
    jsonData['created_at'] = createdAt;
    return jsonData;
  }
}

/// Embedded seller snapshot returned by the compare endpoint.
class Seller {
  int? id;
  String? name;
  String? image;
  String? phone;
  int? rating;
  int? reviewsCount;

  Seller({this.id, this.name, this.image, this.phone, this.rating, this.reviewsCount});

  Seller.fromJson(Map<String, dynamic> json) {
    id = _asInt(json['id']);
    name = _asString(json['name']);
    image = _asString(json['image']);
    phone = _asString(json['phone']);
    rating = _asInt(json['rating']);
    reviewsCount = _asInt(json['reviews_count']);
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData['id'] = id;
    jsonData['name'] = name;
    jsonData['image'] = image;
    jsonData['phone'] = phone;
    jsonData['rating'] = rating;
    jsonData['reviews_count'] = reviewsCount;
    return jsonData;
  }
}
