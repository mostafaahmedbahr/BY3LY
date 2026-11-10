
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

/// Maps a raw list into models, skipping junk entries silently —
/// one malformed entry must never take the whole response down.
List<T>? _parseList<T>(dynamic raw, T Function(Map<String, dynamic>) from) {
  if (raw is! List) return null;
  final out = <T>[];
  for (final e in raw) {
    if (e is Map) out.add(from(Map<String, dynamic>.from(e)));
  }
  return out;
}

class NotificationsModel {
  bool? status;
  String? message;
  Data? data;

  NotificationsModel({this.status, this.message, this.data});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]);
    message = _asString(json["message"]);
    final raw = json["data"];
    data = raw is Map
        ? Data.fromJson(Map<String, dynamic>.from(raw))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["status"] = status;
    jsonData["message"] = message;
    if(data != null) {
      jsonData["data"] = data?.toJson();
    }
    return jsonData;
  }
}

class Data {
  List<Notifications>? notifications;
  Pagination? pagination;
  int? unreadCount;

  Data({this.notifications, this.pagination, this.unreadCount});

  Data.fromJson(Map<String, dynamic> json) {
    notifications = _parseList(json["notifications"], Notifications.fromJson);
    final rawPagination = json["pagination"];
    pagination = rawPagination is Map
        ? Pagination.fromJson(Map<String, dynamic>.from(rawPagination))
        : null;
    unreadCount = _asInt(json["unread_count"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    if(notifications != null) {
      jsonData["notifications"] = notifications?.map((e) => e.toJson()).toList();
    }
    if(pagination != null) {
      jsonData["pagination"] = pagination?.toJson();
    }
    jsonData["unread_count"] = unreadCount;
    return jsonData;
  }
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Pagination({this.currentPage, this.lastPage, this.perPage, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = _asInt(json["current_page"]);
    lastPage = _asInt(json["last_page"]);
    perPage = _asInt(json["per_page"]);
    total = _asInt(json["total"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["current_page"] = currentPage;
    jsonData["last_page"] = lastPage;
    jsonData["per_page"] = perPage;
    jsonData["total"] = total;
    return jsonData;
  }
}

class Notifications {
  String? id;
  String? type;
  String? title;
  String? body;
  dynamic data;
  bool? isRead;
  dynamic readAt;
  String? createdAt;

  Notifications({this.id, this.type, this.title, this.body, this.data, this.isRead, this.readAt, this.createdAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = _asString(json["id"]);
    type = _asString(json["type"]);
    title = _asString(json["title"]);
    body = _asString(json["body"]);
    // Payload can be a Map, a List or null depending on the type.
    data = json["data"];
    isRead = _asBool(json["is_read"]) ?? json["read_at"] != null;
    readAt = json["read_at"];
    createdAt = _asString(json["created_at"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData["id"] = id;
    jsonData["type"] = type;
    jsonData["title"] = title;
    jsonData["body"] = body;
    if(data != null) {
      jsonData["data"] = data;
    }
    jsonData["is_read"] = isRead;
    jsonData["read_at"] = readAt;
    jsonData["created_at"] = createdAt;
    return jsonData;
  }
}