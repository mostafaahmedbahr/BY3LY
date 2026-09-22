
class HowToMakePurchaseModel {
  bool? status;
  String? message;
  Data? data;

  HowToMakePurchaseModel({this.status, this.message, this.data});

  HowToMakePurchaseModel.fromJson(Map<String, dynamic> json) {
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

  static List<HowToMakePurchaseModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(HowToMakePurchaseModel.fromJson).toList();
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

  HowToMakePurchaseModel copyWith({
    bool? status,
    String? message,
    Data? data,
  }) => HowToMakePurchaseModel(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );
}

class Data {
  List<Purchases>? purchases;

  Data({this.purchases});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["purchases"] is List) {
      purchases = json["purchases"] == null ? null : (json["purchases"] as List).map((e) => Purchases.fromJson(e)).toList();
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(purchases != null) {
      _data["purchases"] = purchases?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  Data copyWith({
    List<Purchases>? purchases,
  }) => Data(
    purchases: purchases ?? this.purchases,
  );
}

class Purchases {
  int? id;
  String? title;
  String? message;
  String? image;

  Purchases({this.id, this.title, this.message, this.image});

  Purchases.fromJson(Map<String, dynamic> json) {
    if(json["id"] is num) {
      id = (json["id"] as num).toInt();
    }
    if(json["title"] is String) {
      title = json["title"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["image"] is String) {
      image = json["image"];
    }
  }

  static List<Purchases> fromList(List<Map<String, dynamic>> list) {
    return list.map(Purchases.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["title"] = title;
    _data["message"] = message;
    _data["image"] = image;
    return _data;
  }

  Purchases copyWith({
    int? id,
    String? title,
    String? message,
    String? image,
  }) => Purchases(
    id: id ?? this.id,
    title: title ?? this.title,
    message: message ?? this.message,
    image: image ?? this.image,
  );
}