
class NotificationsModel {
  bool? status;
  String? message;
  Data? data;

  NotificationsModel({this.status, this.message, this.data});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
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

  static List<NotificationsModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(NotificationsModel.fromJson).toList();
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

  NotificationsModel copyWith({
    bool? status,
    String? message,
    Data? data,
  }) => NotificationsModel(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );
}

class Data {
  List<Notifications>? notifications;

  Data({this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["notifications"] is List) {
      notifications = json["notifications"] == null ? null : (json["notifications"] as List).map((e) => Notifications.fromJson(e)).toList();
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(notifications != null) {
      _data["notifications"] = notifications?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  Data copyWith({
    List<Notifications>? notifications,
  }) => Data(
    notifications: notifications ?? this.notifications,
  );
}

class Notifications {
  int? id;
  String? title;
  String? message;
  int? userId;
  String? userName;
  String? userImage;
  String? type;
  int? status;
  String? createdAt;

  Notifications({this.id, this.title, this.message, this.userId, this.userName, this.userImage, this.type, this.status, this.createdAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    if(json["id"] is num) {
      id = (json["id"] as num).toInt();
    }
    if(json["title"] is String) {
      title = json["title"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["user_id"] is num) {
      userId = (json["user_id"] as num).toInt();
    }
    if(json["user_name"] is String) {
      userName = json["user_name"];
    }
    if(json["user_image"] is String) {
      userImage = json["user_image"];
    }
    if(json["type"] is String) {
      type = json["type"];
    }
    if(json["status"] is num) {
      status = (json["status"] as num).toInt();
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<Notifications> fromList(List<Map<String, dynamic>> list) {
    return list.map(Notifications.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["title"] = title;
    _data["message"] = message;
    _data["user_id"] = userId;
    _data["user_name"] = userName;
    _data["user_image"] = userImage;
    _data["type"] = type;
    _data["status"] = status;
    _data["created_at"] = createdAt;
    return _data;
  }

  Notifications copyWith({
    int? id,
    String? title,
    String? message,
    int? userId,
    String? userName,
    String? userImage,
    String? type,
    int? status,
    String? createdAt,
  }) => Notifications(
    id: id ?? this.id,
    title: title ?? this.title,
    message: message ?? this.message,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    userImage: userImage ?? this.userImage,
    type: type ?? this.type,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
}