
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

class BannersModel {
  bool? status;
  String? message;
  List<BannerItem>? banners;

  BannersModel({this.status, this.message, this.banners});

  BannersModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]) ?? json["status"] == 1;
    message = _asString(json["message"]);
    final rawData = json["data"];
    List<dynamic>? rawList;
    if (rawData is List) {
      rawList = rawData;
    } else if (rawData is Map<String, dynamic>) {
      final inner = rawData["banners"] ??
          rawData["data"] ??
          rawData["slides"] ??
          rawData["items"];
      if (inner is List) rawList = inner;
    }
    banners = rawList
            ?.map((e) => BannerItem.fromJson(e))
            .toList() ??
        [];
  }
}

class BannerItem {
  int? id;
  String? image;
  String? title;
  String? description;
  String? link;

  BannerItem({this.id, this.image, this.title, this.description, this.link});

  /// Accepts a full object, a bare image-url string, or a map with
  /// assorted key namings. Unknown shapes become an empty item that
  /// the UI skips instead of crashing the whole list.
  factory BannerItem.fromJson(dynamic json) {
    if (json is String) {
      return BannerItem(image: json.trim().isEmpty ? null : json);
    }
    if (json is! Map) return BannerItem();
    final map = Map<String, dynamic>.from(json);
    return BannerItem(
      id: _asInt(map["id"]),
      image: _asString(map["image"]) ??
          _asString(map["image_url"]) ??
          _asString(map["banner"]) ??
          _asString(map["photo"]) ??
          _asString(map["url"]),
      title: _asString(map["title"]) ?? _asString(map["name"]),
      description:
          _asString(map["description"]) ?? _asString(map["desc"]),
      link: _asString(map["link"]) ??
          _asString(map["url"]) ??
          _asString(map["action_url"]) ??
          _asString(map["redirect"]),
    );
  }
}
