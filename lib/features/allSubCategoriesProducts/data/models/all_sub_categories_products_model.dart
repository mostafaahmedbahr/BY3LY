
class AllSubCategoriesProductsModel {
  bool? status;
  String? message;
  Data? data;

  AllSubCategoriesProductsModel({this.status, this.message, this.data});

  AllSubCategoriesProductsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
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

  Data({this.products});

  Data.fromJson(Map<String, dynamic> json) {
    products = json["products"] == null ? null : (json["products"] as List).map((e) => Products.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(products != null) {
      _data["products"] = products?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Products {
  int? id;
  String? name;
  String? desc;
  String? price;
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

  Products({this.id, this.name, this.desc, this.price, this.oldPrice, this.currency, this.listingType, this.listingTypeLabel, this.furnishing, this.furnishingLabel, this.seller, this.image, this.location, this.cityId, this.categoryId, this.categoryType, this.subCategoryId, this.subCategory, this.date, this.images, this.rate, this.countCommenets, this.commenets, this.reviews, this.reviewsCount, this.isFavourite, this.model, this.marka, this.type, this.createdAt});

  Products.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"]?.toString();
    desc = json["desc"]?.toString();
    price = json["price"]?.toString();

    oldPrice = json["old_price"];

    currency = json["currency"]?.toString();

    listingType = json["listing_type"];
    listingTypeLabel = json["listing_type_label"];

    furnishing = json["furnishing"];
    furnishingLabel = json["furnishing_label"];

    seller = json["seller"] == null
        ? null
        : Seller.fromJson(json["seller"]);

    image = json["image"]?.toString();

    location = json["location"];
    cityId = json["city_id"];

    categoryId = json["category_id"];

    categoryType = json["category_type"]?.toString();

    subCategoryId = json["sub_category_id"];

    subCategory = json["sub_category"]?.toString();

    date = json["date"]?.toString();

    images = json["images"] ?? [];

    // مهم جدًا
    rate = json["rate"]?.toString();

    countCommenets = json["countCommenets"];

    commenets = json["commenets"] ?? [];

    reviews = json["reviews"] ?? [];

    reviewsCount = json["reviews_count"];

    isFavourite = json["isFavourite"];

    model = json["model"]?.toString();

    marka = json["marka"]?.toString();

    type = json["type"]?.toString();

    createdAt = json["created_at"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["desc"] = desc;
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
  double? rating;
  int? reviewsCount;

  Seller({this.id, this.name, this.image, this.phone, this.rating, this.reviewsCount});

  Seller.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    image = json["image"];
    phone = json["phone"];
    rating = json["rating"];
    reviewsCount = json["reviews_count"];
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