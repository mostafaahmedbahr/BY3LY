
class ProductSellerModel {
  bool? status;
  String? message;
  Data? data;

  ProductSellerModel({this.status, this.message, this.data});

  ProductSellerModel.fromJson(Map<String, dynamic> json) {
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
  Seller? seller;
  List<Products>? products;

  Data({this.seller, this.products});

  Data.fromJson(Map<String, dynamic> json) {
    seller = json["seller"] == null ? null : Seller.fromJson(json["seller"]);
    products = json["products"] == null ? null : (json["products"] as List).map((e) => Products.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(seller != null) {
      _data["seller"] = seller?.toJson();
    }
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

class Seller {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? token;
  int? centerId;
  int? cityId;
  String? cityName;
  String? centerName;
  String? createdAt;
  int? sellerRate;
  int? countCommenets;
  List<Commenets>? commenets;

  Seller({this.id, this.name, this.email, this.phone, this.image, this.token, this.centerId, this.cityId, this.cityName, this.centerName, this.createdAt, this.sellerRate, this.countCommenets, this.commenets});

  Seller.fromJson(Map<String, dynamic> json) {
    id = (json["id"] as num).toInt();
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    image = json["image"];
    token = json["token"];
    centerId = (json["center_id"] as num).toInt();
    cityId = (json["city_id"] as num).toInt();
    cityName = json["cityName"];
    centerName = json["centerName"];
    createdAt = json["created_at"];
    sellerRate = (json["seller_rate"] as num).toInt();
    countCommenets = (json["countCommenets"] as num).toInt();
    commenets = json["commenets"] == null ? null : (json["commenets"] as List).map((e) => Commenets.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["email"] = email;
    _data["phone"] = phone;
    _data["image"] = image;
    _data["token"] = token;
    _data["center_id"] = centerId;
    _data["city_id"] = cityId;
    _data["cityName"] = cityName;
    _data["centerName"] = centerName;
    _data["created_at"] = createdAt;
    _data["seller_rate"] = sellerRate;
    _data["countCommenets"] = countCommenets;
    if(commenets != null) {
      _data["commenets"] = commenets?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Commenets {
  int? id;
  String? rate;
  String? commenet;
  String? user;
  String? image;
  String? createdAt;

  Commenets({this.id, this.rate, this.commenet, this.user, this.image, this.createdAt});

  Commenets.fromJson(Map<String, dynamic> json) {
    id = (json["id"] as num).toInt();
    rate = json["rate"];
    commenet = json["commenet"];
    user = json["user"];
    image = json["image"];
    createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["rate"] = rate;
    _data["commenet"] = commenet;
    _data["user"] = user;
    _data["image"] = image;
    _data["created_at"] = createdAt;
    return _data;
  }
}