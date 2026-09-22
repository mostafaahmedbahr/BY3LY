
class SellAllBestViewModel {
  bool? status;
  String? message;
  Data? data;

  SellAllBestViewModel({this.status, this.message, this.data});

  SellAllBestViewModel.fromJson(Map<String, dynamic> json) {
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

  Products({this.id, this.uniqueNumber, this.name, this.desc, this.price, this.image, this.images, this.rate, this.sellerRate, this.countCommenets, this.commenets, this.isFavourite, this.model, this.marka, this.type, this.view, this.sellerId, this.sellerName, this.sellerImage, this.sellerPhone, this.lat, this.long, this.status, this.negotiable, this.communication, this.address, this.createdAt});

  Products.fromJson(Map<String, dynamic> json) {
    id = (json["id"] as num).toInt();
    uniqueNumber = json["unique_number"];
    name = json["name"];
    desc = json["desc"];
    price = json["price"];
    image = json["image"];
    images = json["images"] == null ? null : (json["images"] as List).map((e) => Images.fromJson(e)).toList();
    rate = (json["rate"] as num).toInt();
    sellerRate = (json["seller_rate"] as num).toInt();
    countCommenets = (json["countCommenets"] as num).toInt();
    commenets = json["commenets"] ?? [];
    isFavourite = json["isFavourite"];
    model = json["model"];
    marka = json["marka"];
    type = json["type"];
    view = (json["view"] as num).toInt();
    sellerId = (json["seller_id"] as num).toInt();
    sellerName = json["seller_name"];
    sellerImage = json["seller_image"];
    sellerPhone = json["seller_phone"];
    lat = json["lat"];
    long = json["long"];
    status = (json["status"] as num).toInt();
    negotiable = (json["negotiable"] as num).toInt();
    communication = (json["communication"] as num).toInt();
    address = json["address"];
    createdAt = json["created_at"];
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
}

class Images {
  int? id;
  String? image;

  Images({this.id, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = (json["id"] as num).toInt();
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["image"] = image;
    return _data;
  }
}