
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
    if(json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
  }

  static List<FavDataModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(FavDataModel.fromJson).toList();
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

  FavDataModel copyWith({
    bool? status,
    String? message,
    Data? data,
  }) => FavDataModel(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );
}

class Data {
  List<Favourites>? favourites;

  Data({this.favourites});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["favourites"] is List) {
      favourites = json["favourites"] == null ? null : (json["favourites"] as List).map((e) => Favourites.fromJson(e)).toList();
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(favourites != null) {
      _data["favourites"] = favourites?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  Data copyWith({
    List<Favourites>? favourites,
  }) => Data(
    favourites: favourites ?? this.favourites,
  );
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

  Favourites({this.id, this.uniqueNumber, this.name, this.desc, this.price, this.image, this.images, this.rate, this.sellerRate, this.countCommenets, this.commenets, this.isFavourite, this.model, this.marka, this.type, this.view, this.sellerId, this.sellerName, this.sellerImage, this.sellerPhone, this.lat, this.long, this.status, this.negotiable, this.communication, this.address, this.createdAt});

  Favourites.fromJson(Map<String, dynamic> json) {
    id = _asInt(json["id"]);
    uniqueNumber = _asString(json["unique_number"]);
    name = _asString(json["name"]);
    desc = _asString(json["desc"]);
    price = _asString(json["price"]);
    image = _asString(json["image"]);
    if(json["images"] is List) {
      images = json["images"] == null ? null : (json["images"] as List).map((e) => Images.fromJson(e)).toList();
    }
    rate = _asInt(json["rate"]);
    sellerRate = _asInt(json["seller_rate"]);
    countCommenets = _asInt(json["countCommenets"]);
    if(json["commenets"] is List) {
      commenets = json["commenets"] ?? [];
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
  }

  static List<Favourites> fromList(List<Map<String, dynamic>> list) {
    return list.map(Favourites.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["unique_number"] = uniqueNumber;
    _data["name"] = name;
    _data["desc"] = desc;
    _data["price"] = price;
    _data["image"] = image;
    if(images != null) {
      _data["images"] = images?.map((e) => e.toJson()).toList();
    }
    _data["rate"] = rate;
    _data["seller_rate"] = sellerRate;
    _data["countCommenets"] = countCommenets;
    if(commenets != null) {
      _data["commenets"] = commenets;
    }
    _data["isFavourite"] = isFavourite;
    _data["model"] = model;
    _data["marka"] = marka;
    _data["type"] = type;
    _data["view"] = view;
    _data["seller_id"] = sellerId;
    _data["seller_name"] = sellerName;
    _data["seller_image"] = sellerImage;
    _data["seller_phone"] = sellerPhone;
    _data["lat"] = lat;
    _data["long"] = long;
    _data["status"] = status;
    _data["negotiable"] = negotiable;
    _data["communication"] = communication;
    _data["address"] = address;
    _data["created_at"] = createdAt;
    return _data;
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["image"] = image;
    return _data;
  }

  Images copyWith({
    int? id,
    String? image,
  }) => Images(
    id: id ?? this.id,
    image: image ?? this.image,
  );
}