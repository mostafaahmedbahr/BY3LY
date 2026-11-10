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

class FavDataModel {
  bool? status;
  String? message;
  Data? data;

  FavDataModel({this.status, this.message, this.data});

  FavDataModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]) ?? json["status"] == 1;
    message = _asString(json["message"]);
    if (json["data"] is Map<String, dynamic>) {
      data = Data.fromJson(json["data"] as Map<String, dynamic>);
    } else {
      data = null;
    }
  }

  static List<FavDataModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(FavDataModel.fromJson).toList();
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

  FavDataModel copyWith({bool? status, String? message, Data? data}) =>
      FavDataModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );
}

class Data {
  List<Favourites>? favourites;

  Data({this.favourites});

  Data.fromJson(Map<String, dynamic> json) {
    if (json["favourites"] is List) {
      favourites = (json["favourites"] as List)
          .whereType<Map<String, dynamic>>()
          .map(Favourites.fromJson)
          .toList();
    } else {
      favourites = null;
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    if (favourites != null) {
      jsonData["favourites"] = favourites?.map((e) => e.toJson()).toList();
    }
    return jsonData;
  }

  Data copyWith({List<Favourites>? favourites}) =>
      Data(favourites: favourites ?? this.favourites);
}

class Favourites {
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

  Favourites({
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

  Favourites.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    uniqueNumber = _asString(json["unique_number"]);
    name = _asString(json["name"]);
    desc = _asString(json["desc"]);
    price = _asString(json["price"]);
    image = _asString(json["image"]);
    if (json["images"] is List) {
      images = [];
      for (final e in (json["images"] as List)) {
        if (e is Map<String, dynamic>) {
          images!.add(Images.fromJson(e));
        } else if (e is String && e.trim().isNotEmpty) {
          images!.add(Images(image: e.trim()));
        }
      }
    } else {
      images = null;
    }
    rate = _asInt(json["rate"]);
    sellerRate = _asInt(json["seller_rate"]);
    countCommenets = _asInt(json["countCommenets"]);
    if (json["commenets"] is List) {
      commenets = (json["commenets"] as List).toList();
    } else {
      commenets = null;
    }
    isFavourite = _asBool(json["isFavourite"]) ?? true;
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

  static List<Favourites> fromList(List<Map<String, dynamic>> list) {
    return list.map(Favourites.fromJson).toList();
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

  Favourites copyWith({
    int? id,
    String? uniqueNumber,
    String? name,
    String? desc,
    String? price,
    String? image,
    List<Images>? images,
    int? rate,
    int? sellerRate,
    int? countCommenets,
    List<dynamic>? commenets,
    bool? isFavourite,
    String? model,
    String? marka,
    String? type,
    int? view,
    int? sellerId,
    String? sellerName,
    String? sellerImage,
    String? sellerPhone,
    String? lat,
    String? long,
    int? status,
    int? negotiable,
    int? communication,
    String? address,
    String? createdAt,
    bool? isUrgent,
    int? views,
  }) => Favourites(
    id: id ?? this.id,
    uniqueNumber: uniqueNumber ?? this.uniqueNumber,
    name: name ?? this.name,
    desc: desc ?? this.desc,
    price: price ?? this.price,
    image: image ?? this.image,
    images: images ?? this.images,
    rate: rate ?? this.rate,
    sellerRate: sellerRate ?? this.sellerRate,
    countCommenets: countCommenets ?? this.countCommenets,
    commenets: commenets ?? this.commenets,
    isFavourite: isFavourite ?? this.isFavourite,
    model: model ?? this.model,
    marka: marka ?? this.marka,
    type: type ?? this.type,
    view: view ?? this.view,
    sellerId: sellerId ?? this.sellerId,
    sellerName: sellerName ?? this.sellerName,
    sellerImage: sellerImage ?? this.sellerImage,
    sellerPhone: sellerPhone ?? this.sellerPhone,
    lat: lat ?? this.lat,
    long: long ?? this.long,
    status: status ?? this.status,
    negotiable: negotiable ?? this.negotiable,
    communication: communication ?? this.communication,
    address: address ?? this.address,
    createdAt: createdAt ?? this.createdAt,
    isUrgent: isUrgent ?? this.isUrgent,
    views: views ?? this.views,
  );
}

class Images {
  int? id;
  String? image;

  Images({this.id, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    image = _asString(json["image"]);
  }

  static List<Images> fromList(List<Map<String, dynamic>> list) {
    return list.map(Images.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["image"] = image;
    return jsonData;
  }

  Images copyWith({int? id, String? image}) =>
      Images(id: id ?? this.id, image: image ?? this.image);
}
