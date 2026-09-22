
class FavDataModel {
  bool? status;
  String? message;
  Data? data;

  FavDataModel({this.status, this.message, this.data});

  FavDataModel.fromJson(Map<String, dynamic> json) {
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
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
    if(json["id"] is num) {
      id = (json["id"] as num).toInt();
    }
    if(json["unique_number"] is String) {
      uniqueNumber = json["unique_number"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["desc"] is String) {
      desc = json["desc"];
    }
    if(json["price"] is String) {
      price = json["price"];
    }
    if(json["image"] is String) {
      image = json["image"];
    }
    if(json["images"] is List) {
      images = json["images"] == null ? null : (json["images"] as List).map((e) => Images.fromJson(e)).toList();
    }
    if(json["rate"] is num) {
      rate = (json["rate"] as num).toInt();
    }
    if(json["seller_rate"] is num) {
      sellerRate = (json["seller_rate"] as num).toInt();
    }
    if(json["countCommenets"] is num) {
      countCommenets = (json["countCommenets"] as num).toInt();
    }
    if(json["commenets"] is List) {
      commenets = json["commenets"] ?? [];
    }
    if(json["isFavourite"] is bool) {
      isFavourite = json["isFavourite"];
    }
    if(json["model"] is String) {
      model = json["model"];
    }
    if(json["marka"] is String) {
      marka = json["marka"];
    }
    if(json["type"] is String) {
      type = json["type"];
    }
    if(json["view"] is num) {
      view = (json["view"] as num).toInt();
    }
    if(json["seller_id"] is num) {
      sellerId = (json["seller_id"] as num).toInt();
    }
    if(json["seller_name"] is String) {
      sellerName = json["seller_name"];
    }
    if(json["seller_image"] is String) {
      sellerImage = json["seller_image"];
    }
    if(json["seller_phone"] is String) {
      sellerPhone = json["seller_phone"];
    }
    if(json["lat"] is String) {
      lat = json["lat"];
    }
    if(json["long"] is String) {
      long = json["long"];
    }
    if(json["status"] is num) {
      status = (json["status"] as num).toInt();
    }
    if(json["negotiable"] is num) {
      negotiable = (json["negotiable"] as num).toInt();
    }
    if(json["communication"] is num) {
      communication = (json["communication"] as num).toInt();
    }
    if(json["address"] is String) {
      address = json["address"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
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
    if(json["id"] is num) {
      id = (json["id"] as num).toInt();
    }
    if(json["image"] is String) {
      image = json["image"];
    }
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