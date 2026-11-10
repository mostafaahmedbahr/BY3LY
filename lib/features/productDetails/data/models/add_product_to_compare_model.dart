
class AddProductToCompareModel {
  bool? status;
  String? message;
  List<Data>? data;

  AddProductToCompareModel({this.status, this.message, this.data});

  AddProductToCompareModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["status"] = status;
    jsonData["message"] = message;
    if(data != null) {
      jsonData["data"] = data?.map((e) => e.toJson()).toList();
    }
    return jsonData;
  }
}

class Data {
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

  Data({this.id, this.uniqueNumber, this.name, this.desc, this.price, this.image, this.images, this.rate, this.sellerRate, this.countCommenets, this.commenets, this.isFavourite, this.model, this.marka, this.type, this.view, this.sellerId, this.sellerName, this.sellerImage, this.sellerPhone, this.lat, this.long, this.status, this.negotiable, this.communication, this.address, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["unique_number"] = uniqueNumber;
    jsonData["name"] = name;
    jsonData["desc"] = desc;
    jsonData["price"] = price;
    jsonData["image"] = image;
    if(images != null) {
      jsonData["images"] = images?.map((e) => e.toJson()).toList();
    }
    jsonData["rate"] = rate;
    jsonData["seller_rate"] = sellerRate;
    jsonData["countCommenets"] = countCommenets;
    if(commenets != null) {
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
    return jsonData;
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
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["image"] = image;
    return jsonData;
  }
}