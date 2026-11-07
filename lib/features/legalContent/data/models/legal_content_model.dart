/// The static legal pages served by the API:
/// `GET /api/about`, `GET /api/terms`, `GET /api/privacy`.
enum LegalContentType { about, terms, privacy }

String? _asString(dynamic v) => v?.toString();

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

class LegalContentModel {
  bool? status;
  String? message;
  LegalContentData? data;

  LegalContentModel({this.status, this.message, this.data});

  LegalContentModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]) ?? (json["status"] == 1);
    message = _asString(json["message"]);
    data = json["data"] == null
        ? null
        : LegalContentData.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result["status"] = status;
    result["message"] = message;
    if (data != null) {
      result["data"] = data?.toJson();
    }
    return result;
  }
}

class LegalContentData {
  String? title;

  /// Body of the page as HTML.
  String? content;
  String? language;
  String? direction;
  String? updatedAt;

  LegalContentData({
    this.title,
    this.content,
    this.language,
    this.direction,
    this.updatedAt,
  });

  LegalContentData.fromJson(Map<String, dynamic> json) {
    title = _asString(json["title"]);
    // The pages are served under `content`; `html` is accepted as a
    // fallback so an endpoint answering with the older key still renders.
    content = _asString(json["content"]) ?? _asString(json["html"]);
    language = _asString(json["language"]);
    direction = _asString(json["direction"]);
    updatedAt = _asString(json["updated_at"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result["title"] = title;
    result["content"] = content;
    result["language"] = language;
    result["direction"] = direction;
    result["updated_at"] = updatedAt;
    return result;
  }

  /// Text direction of the page (`rtl` unless the server says `ltr`).
  bool get isRtl => (direction ?? 'rtl').toLowerCase() != 'ltr';
}
