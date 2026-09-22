
class AllProductsSearchModel {
  bool? status;
  String? message;
  Data? data;

  AllProductsSearchModel({this.status, this.message, this.data});

  AllProductsSearchModel.fromJson(Map<String, dynamic> json) {
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

  static List<AllProductsSearchModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => AllProductsSearchModel.fromJson(map)).toList();
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

  AllProductsSearchModel copyWith({
    bool? status,
    String? message,
    Data? data,
  }) => AllProductsSearchModel(
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
    return list.map((map) => Data.fromJson(map)).toList();
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
  String? createdAt;

  Products({this.id, this.name, this.desc, this.price, this.image, this.images, this.rate, this.countCommenets, this.commenets, this.isFavourite, this.model, this.marka, this.type, this.createdAt});

  Products.fromJson(Map<String, dynamic> json) {
    if(json["id"] is num) {
      id = (json["id"] as num).toInt();
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
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<Products> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => Products.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
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
    _data["created_at"] = createdAt;
    return _data;
  }

  Products copyWith({
    int? id,
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
    String? createdAt,
  }) => Products(
    id: id ?? this.id,
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
    return list.map((map) => Images.fromJson(map)).toList();
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