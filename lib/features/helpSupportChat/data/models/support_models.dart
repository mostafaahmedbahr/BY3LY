/// Safe parsing helpers for the support chat API. The backend may send the
/// same field as `int`, `double`, `String` or `null` depending on the
/// endpoint, so every value is normalised before it reaches a strongly typed
/// field.
int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString().trim());
}

String? _toStr(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

bool? _toBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value.toString().trim().toLowerCase();
  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;
  return null;
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

class SupportMessageModel {
  int? id;
  int? conversationId;
  int? senderId;
  String? senderRole;
  bool? isMine;
  bool? isFromSupport;
  String? type;
  String? body;
  String? image;
  bool? isRead;
  String? readAt;
  bool? isDeleted;
  String? createdAt;

  SupportMessageModel({
    this.id,
    this.conversationId,
    this.senderId,
    this.senderRole,
    this.isMine,
    this.isFromSupport,
    this.type,
    this.body,
    this.image,
    this.isRead,
    this.readAt,
    this.isDeleted,
    this.createdAt,
  });

  SupportMessageModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    conversationId = _toInt(json['conversation_id']);
    senderId = _toInt(json['sender_id']);
    senderRole = _toStr(json['sender_role']);
    isMine = _toBool(json['is_mine']);
    isFromSupport = _toBool(json['is_from_support']);
    type = _toStr(json['type']);
    body = _toStr(json['body']);
    image = _toStr(json['image']);
    isRead = _toBool(json['is_read']);
    readAt = _toStr(json['read_at']);
    isDeleted = _toBool(json['is_deleted']);
    createdAt = _toStr(json['created_at']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['conversation_id'] = conversationId;
    data['sender_id'] = senderId;
    data['sender_role'] = senderRole;
    data['is_mine'] = isMine;
    data['is_from_support'] = isFromSupport;
    data['type'] = type;
    data['body'] = body;
    data['image'] = image;
    data['is_read'] = isRead;
    data['read_at'] = readAt;
    data['is_deleted'] = isDeleted;
    data['created_at'] = createdAt;
    return data;
  }

  bool get isImage => type == 'image' && (image?.isNotEmpty ?? false);

  bool get fromSupport =>
      isFromSupport == true ||
      (senderRole != null && senderRole!.toLowerCase() != 'user');

  DateTime? get createdAtDate =>
      createdAt == null ? null : DateTime.tryParse(createdAt!)?.toLocal();

  SupportMessageModel copyWith({
    String? body,
    String? image,
    bool? isRead,
    String? readAt,
    bool? isDeleted,
  }) {
    return SupportMessageModel(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderRole: senderRole,
      isMine: isMine,
      isFromSupport: isFromSupport,
      type: type,
      body: body ?? this.body,
      image: image ?? this.image,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt,
    );
  }
}

class SupportPagination {
  int? total;
  int? perPage;
  int? currentPage;
  int? totalPages;
  int? lastPage;

  SupportPagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.totalPages,
    this.lastPage,
  });

  SupportPagination.fromJson(Map<String, dynamic> json) {
    total = _toInt(json['total']);
    perPage = _toInt(json['per_page']);
    currentPage = _toInt(json['current_page']);
    totalPages = _toInt(json['total_pages']) ?? _toInt(json['last_page']);
    lastPage = _toInt(json['last_page']) ?? totalPages;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total;
    data['per_page'] = perPage;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    data['last_page'] = lastPage;
    return data;
  }
}

class SupportConversationResponse {
  bool? status;
  String? message;
  int? conversationId;

  SupportConversationResponse({
    this.status,
    this.message,
    this.conversationId,
  });

  SupportConversationResponse.fromJson(Map<String, dynamic> json) {
    status = _toBool(json['status']);
    message = _toStr(json['message']);
    // The thread payload differs per release; look for the id in every
    // shape the backend is known to produce.
    final data = _asMap(json['data']);
    final conversation = _asMap(data?['conversation']) ?? data;
    conversationId = _toInt(
      conversation?['id'] ?? data?['conversation_id'] ?? data?['id'],
    );
  }
}

class SupportMessagesResponse {
  bool? status;
  String? message;
  List<SupportMessageModel>? messages;
  SupportPagination? pagination;

  SupportMessagesResponse({
    this.status,
    this.message,
    this.messages,
    this.pagination,
  });

  SupportMessagesResponse.fromJson(Map<String, dynamic> json) {
    status = _toBool(json['status']);
    message = _toStr(json['message']);
    final data = _asMap(json['data']);
    messages = data?['messages'] == null
        ? null
        : (data!['messages'] as List)
              .whereType<Map<String, dynamic>>()
              .map(SupportMessageModel.fromJson)
              .toList();
    pagination = data?['pagination'] == null
        ? null
        : SupportPagination.fromJson(data!['pagination']);
  }
}

class SendSupportMessageResponse {
  bool? status;
  String? message;
  SupportMessageModel? supportMessage;

  SendSupportMessageResponse({this.status, this.message, this.supportMessage});

  SendSupportMessageResponse.fromJson(Map<String, dynamic> json) {
    status = _toBool(json['status']);
    final data = _asMap(json['data']);
    // `data.message` holds the created message object; some releases send
    // it at the top level instead.
    final messageMap = _asMap(data?['message']) ?? _asMap(json['message']);
    if (messageMap != null) {
      supportMessage = SupportMessageModel.fromJson(messageMap);
      // Top-level `message` is the created-message object on the send
      // endpoint; only keep it as text when it actually is text.
      message = _toStr(json['message'] is String ? json['message'] : null);
    } else {
      message = _toStr(json['message']);
    }
  }
}

class SupportUnreadResponse {
  bool? status;
  String? message;
  int? unreadCount;

  SupportUnreadResponse({this.status, this.message, this.unreadCount});

  SupportUnreadResponse.fromJson(Map<String, dynamic> json) {
    status = _toBool(json['status']);
    message = _toStr(json['message']);
    final data = _asMap(json['data']);
    unreadCount = _toInt(data?['unread_count']) ?? _toInt(json['unread_count']);
  }
}

class SupportReadResponse {
  bool? status;
  String? message;
  int? unreadCount;

  SupportReadResponse({this.status, this.message, this.unreadCount});

  SupportReadResponse.fromJson(Map<String, dynamic> json) {
    status = _toBool(json['status']);
    message = _toStr(json['message']);
    final data = _asMap(json['data']);
    unreadCount = _toInt(data?['unread_count']) ?? _toInt(json['unread_count']);
  }
}
