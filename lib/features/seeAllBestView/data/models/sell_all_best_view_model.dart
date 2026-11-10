String? _asString(dynamic v) => v?.toString();

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

class SellAllBestViewModel {
  bool? status;
  String? message;
  Data? data;

  SellAllBestViewModel({this.status, this.message, this.data});

  SellAllBestViewModel.fromJson(Map<String, dynamic> json) {
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

  Data({this.products});

  Data.fromJson(Map<String, dynamic> json) {
    products = _parseList(json["products"], Products.fromJson);
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
  String? uniqueNumber;
  String? name;
  String? desc;
  String? price;
  String? image;
  List<Images>? images;
  int? rate;
  int? sellerRate;
  int? countCommenets;
  List<dynamic>? commenets;
  bool? isFavourite;
  String? model;
  String? marka;
  String? type;
  int? view;
  int? sellerId;
  String? sellerName;
  String? sellerImage;
  String? sellerPhone;
  String? lat;
  String? long;
  int? status;
  int? negotiable;
  int? communication;
  String? address;
  String? createdAt;
  bool? isUrgent;
  int? views;

  Products({
    this.id,
    this.uniqueNumber,
    this.name,
    this.desc,
    this.price,
    this.image,
    this.images,
    this.rate,
    this.sellerRate,
    this.countCommenets,
    this.commenets,
    this.isFavourite,
    this.model,
    this.marka,
    this.type,
    this.view,
    this.sellerId,
    this.sellerName,
    this.sellerImage,
    this.sellerPhone,
    this.lat,
    this.long,
    this.status,
    this.negotiable,
    this.communication,
    this.address,
    this.createdAt,
    this.isUrgent,
    this.views,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    uniqueNumber = _asString(json["unique_number"]);
    name = _asString(json["name"]);
    desc = _asString(json["desc"]);
    price = _asString(json["price"]);
    image = _asString(json["image"]);
    images = _parseList(json["images"], Images.fromJson);
    rate = _asInt(json["rate"]);
    sellerRate = _asInt(json["seller_rate"]);
    countCommenets = _asInt(json["countCommenets"]);
    commenets = json["commenets"] is List ? json["commenets"] as List : null;
    isFavourite = _asBool(json["isFavourite"]);
    model = _asString(json["model"]);
    marka = _asString(json["marka"]);
    type = _asString(json["type"]);
    view = _asInt(json["view"]);
    sellerId = _asInt(json["seller_id"]);
    sellerName = _asString(json["seller_name"]);
    sellerImage = _asString(json["seller_image"]);
    sellerPhone = _asString(json["seller_phone"]);
    lat = _asString(json["lat"]);
    long = _asString(json["long"]);
    status = _asInt(json["status"]);
    negotiable = _asInt(json["negotiable"]);
    communication = _asInt(json["communication"]);
    address = _asString(json["address"]);
    createdAt = _asString(json["created_at"]);
    isUrgent = _asBool(json["is_urgent"]);
    views = _asInt(json["views"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["unique_number"] = uniqueNumber;
    jsonData["name"] = name;
    jsonData["desc"] = desc;
    jsonData["price"] = price;
    jsonData["image"] = image;
    if (images != null) {
      jsonData["images"] = images?.map((e) => e.toJson()).toList();
    }
    jsonData["rate"] = rate;
    jsonData["seller_rate"] = sellerRate;
    jsonData["countCommenets"] = countCommenets;
    if (commenets != null) {
      jsonData["commenets"] = commenets;
    }
    jsonData["isFavourite"] = isFavourite;
    jsonData["model"] = model;
    jsonData["marka"] = marka;
    jsonData["type"] = type;
    jsonData["view"] = view;
    jsonData["seller_id"] = sellerId;
    jsonData["seller_name"] = sellerName;
    jsonData["seller_image"] = sellerImage;
    jsonData["seller_phone"] = sellerPhone;
    jsonData["lat"] = lat;
    jsonData["long"] = long;
    jsonData["status"] = status;
    jsonData["negotiable"] = negotiable;
    jsonData["communication"] = communication;
    jsonData["address"] = address;
    jsonData["created_at"] = createdAt;
    jsonData["is_urgent"] = isUrgent;
    jsonData["views"] = views;
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
