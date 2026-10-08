
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

class NotificationsModel {
  bool? status;
  String? message;
  Data? data;

  NotificationsModel({this.status, this.message, this.data});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    status = _asBool(json["status"]) ?? json["status"] == 1;
    message = _asString(json["message"]);
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
  List<Notifications>? notifications;
  Pagination? pagination;
  int? unreadCount;

  Data({this.notifications, this.pagination, this.unreadCount});

  Data.fromJson(Map<String, dynamic> json) {
    notifications = json["notifications"] == null ? null : (json["notifications"] as List).map((e) => Notifications.fromJson(e)).toList();
    pagination = json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]);
    unreadCount = _asInt(json["unread_count"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(notifications != null) {
      _data["notifications"] = notifications?.map((e) => e.toJson()).toList();
    }
    if(pagination != null) {
      _data["pagination"] = pagination?.toJson();
    }
    _data["unread_count"] = unreadCount;
    return _data;
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["current_page"] = currentPage;
    _data["last_page"] = lastPage;
    _data["per_page"] = perPage;
    _data["total"] = total;
    return _data;
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["type"] = type;
    _data["title"] = title;
    _data["body"] = body;
    if(data != null) {
      _data["data"] = data;
    }
    _data["is_read"] = isRead;
    _data["read_at"] = readAt;
    _data["created_at"] = createdAt;
    return _data;
  }
}