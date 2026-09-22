
class MyAdsDataModel {
  bool? status;
  String? message;
  Data? data;

  MyAdsDataModel({this.status, this.message, this.data});

  MyAdsDataModel.fromJson(Map<String, dynamic> json) {
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

  static List<MyAdsDataModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(MyAdsDataModel.fromJson).toList();
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

  MyAdsDataModel copyWith({
    bool? status,
    String? message,
    Data? data,
  }) => MyAdsDataModel(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );
}

class Data {
  List<Products>? products;

  Data({this.products});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["products"] is List) {
      products = json["products"] == null ? null : (json["products"] as List).map((e) => Products.fromJson(e)).toList();
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(products != null) {
      _data["products"] = products?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  Data copyWith({
    List<Products>? products,
  }) => Data(
    products: products ?? this.products,
  );
}

class Products {
  int? id;
  String? uniqueNumber;
  String? name;
  String? desc;
  String? price;
  String? image;
  List<Images>? images;
  String? rate;
  int? countCommenets;
  List<dynamic>? commenets;
  bool? isFavourite;
  String? model;
  String? marka;
  String? type;
  int? view;
  int? sellerId;
  String? sellerName;
  String? lat;
  String? long;
  int? status;
  String? address;
  String? createdAt;

  Products({this.id, this.uniqueNumber, this.name, this.desc, this.price, this.image, this.images, this.rate, this.countCommenets, this.commenets, this.isFavourite, this.model, this.marka, this.type, this.view, this.sellerId, this.sellerName, this.lat, this.long, this.status, this.address, this.createdAt});

  Products.fromJson(Map<String, dynamic> json) {
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
    if(json["rate"] is String) {
      rate = json["rate"];
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
    if(json["lat"] is String) {
      lat = json["lat"];
    }
    if(json["long"] is String) {
      long = json["long"];
    }
    if(json["status"] is num) {
      status = (json["status"] as num).toInt();
    }
    if(json["address"] is String) {
      address = json["address"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<Products> fromList(List<Map<String, dynamic>> list) {
    return list.map(Products.fromJson).toList();
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
    _data["lat"] = lat;
    _data["long"] = long;
    _data["status"] = status;
    _data["address"] = address;
    _data["created_at"] = createdAt;
    return _data;
  }

  Products copyWith({
    int? id,
    String? uniqueNumber,
    String? name,
    String? desc,
    String? price,
    String? image,
    List<Images>? images,
    String? rate,
    int? countCommenets,
    List<dynamic>? commenets,
    bool? isFavourite,
    String? model,
    String? marka,
    String? type,
    int? view,
    int? sellerId,
    String? sellerName,
    String? lat,
    String? long,
    int? status,
    String? address,
    String? createdAt,
  }) => Products(
    id: id ?? this.id,
    uniqueNumber: uniqueNumber ?? this.uniqueNumber,
    name: name ?? this.name,
    desc: desc ?? this.desc,
    price: price ?? this.price,
    image: image ?? this.image,
    images: images ?? this.images,
    rate: rate ?? this.rate,
    countCommenets: countCommenets ?? this.countCommenets,
    commenets: commenets ?? this.commenets,
    isFavourite: isFavourite ?? this.isFavourite,
    model: model ?? this.model,
    marka: marka ?? this.marka,
    type: type ?? this.type,
    view: view ?? this.view,
    sellerId: sellerId ?? this.sellerId,
    sellerName: sellerName ?? this.sellerName,
    lat: lat ?? this.lat,
    long: long ?? this.long,
    status: status ?? this.status,
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