/// Safe parsing helpers for the chat API. The backend may send the same field
/// as `int`, `double`, `String` or `null` depending on the endpoint, so every
/// value is normalised before it reaches a strongly typed field.
int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString().trim());
}

num? _toNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  return num.tryParse(value.toString().replaceAll(',', '').trim());
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

/// Groups a number with thousands separators: `4500000` -> `4,500,000`.
String formatChatPrice(num? value) {
  if (value == null) return '';
  final isWhole = value == value.roundToDouble();
  final text = isWhole ? value.toInt().toString() : value.toString();
  final parts = text.split('.');
  final digits = parts.first.replaceAll('-', '');
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  final prefix = text.startsWith('-') ? '-' : '';
  return parts.length > 1 ? '$prefix$buffer.${parts.last}' : '$prefix$buffer';
}

class ChatUserModel {
  int? id;
  String? name;
  String? image;

  ChatUserModel({this.id, this.name, this.image});

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = _toStr(json['name']);
    image = _toStr(json['image']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class ChatProductModel {
  int? id;
  String? name;
  num? price;
  String? image;

  ChatProductModel({this.id, this.name, this.price, this.image});

  ChatProductModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = _toStr(json['name']);
    price = _toNum(json['price']);
    image = _toStr(json['image']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['image'] = image;
    return data;
  }

  String get priceLabel => formatChatPrice(price);
}

class ChatMessageModel {
  int? id;
  int? conversationId;
  int? senderId;
  bool? isMine;
  String? type;
  String? body;
  String? image;
  bool? isRead;
  String? readAt;
  bool? isDeleted;
  String? createdAt;

  ChatMessageModel({
    this.id,
    this.conversationId,
    this.senderId,
    this.isMine,
    this.type,
    this.body,
    this.image,
    this.isRead,
    this.readAt,
    this.isDeleted,
    this.createdAt,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    conversationId = _toInt(json['conversation_id']);
    senderId = _toInt(json['sender_id']);
    isMine = _toBool(json['is_mine']);
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
    data['is_mine'] = isMine;
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

  DateTime? get createdAtDate =>
      createdAt == null ? null : DateTime.tryParse(createdAt!)?.toLocal();

  ChatMessageModel copyWith({
    String? body,
    String? image,
    bool? isRead,
    String? readAt,
    bool? isDeleted,
  }) {
    return ChatMessageModel(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      isMine: isMine,
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

class ConversationModel {
  int? id;
  bool? isSeller;
  ChatUserModel? otherUser;
  ChatProductModel? product;
  ChatMessageModel? lastMessage;
  int? unreadCount;
  String? updatedAt;

  ConversationModel({
    this.id,
    this.isSeller,
    this.otherUser,
    this.product,
    this.lastMessage,
    this.unreadCount,
    this.updatedAt,
  });

  ConversationModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    isSeller = _toBool(json['is_seller']);
    otherUser = json['other_user'] == null
        ? null
        : ChatUserModel.fromJson(json['other_user']);
    product = json['product'] == null
        ? null
        : ChatProductModel.fromJson(json['product']);
    lastMessage = json['last_message'] == null
        ? null
        : ChatMessageModel.fromJson(json['last_message']);
    unreadCount = _toInt(json['unread_count']) ?? 0;
    updatedAt = _toStr(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['is_seller'] = isSeller;
    if (otherUser != null) data['other_user'] = otherUser!.toJson();
    if (product != null) data['product'] = product!.toJson();
    if (lastMessage != null) data['last_message'] = lastMessage!.toJson();
    data['unread_count'] = unreadCount;
    data['updated_at'] = updatedAt;
    return data;
  }

  ConversationModel copyWith({
    ChatMessageModel? lastMessage,
    int? unreadCount,
    String? updatedAt,
  }) {
    return ConversationModel(
      id: id,
      isSeller: isSeller,
      otherUser: otherUser,
      product: product,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ChatPagination {
  int? total;
  int? perPage;
  int? currentPage;
  int? totalPages;
  int? lastPage;

  ChatPagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.totalPages,
    this.lastPage,
  });

  ChatPagination.fromJson(Map<String, dynamic> json) {
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

class ConversationsResponse {
  bool? status;
  String? message;
  ConversationsData? data;

  ConversationsResponse({this.status, this.message, this.data});

  ConversationsResponse.fromJson(Map<String, dynamic> json) {
    status = _toBool(json['status']);
    message = _toStr(json['message']);
    data = json['data'] == null
        ? null
        : ConversationsData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) data['data'] = this.data!.toJson();
    return data;
  }
}

class ConversationsData {
  List<ConversationModel>? conversations;
  ChatPagination? pagination;
  int? unreadCount;

  ConversationsData({this.conversations, this.pagination, this.unreadCount});

  ConversationsData.fromJson(Map<String, dynamic> json) {
    conversations = json['conversations'] == null
        ? null
        : (json['conversations'] as List)
              .whereType<Map<String, dynamic>>()
              .map(ConversationModel.fromJson)
              .toList();
    pagination = json['pagination'] == null
        ? null
        : ChatPagination.fromJson(json['pagination']);
    unreadCount = _toInt(json['unread_count']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (conversations != null) {
      data['conversations'] = conversations!.map((e) => e.toJson()).toList();
    }
    if (pagination != null) data['pagination'] = pagination!.toJson();
    data['unread_count'] = unreadCount;
    return data;
  }
}

class ChatMessagesResponse {
  bool? status;
  String? message;
  ChatMessagesData? data;

  ChatMessagesResponse({this.status, this.message, this.data});

  ChatMessagesResponse.fromJson(Map<String, dynamic> json) {
    status = _toBool(json['status']);
    message = _toStr(json['message']);
    data = json['data'] == null
        ? null
        : ChatMessagesData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) data['data'] = this.data!.toJson();
    return data;
  }
}

class ChatMessagesData {
  List<ChatMessageModel>? messages;
  ChatPagination? pagination;

  ChatMessagesData({this.messages, this.pagination});

  ChatMessagesData.fromJson(Map<String, dynamic> json) {
    messages = json['messages'] == null
        ? null
        : (json['messages'] as List)
              .whereType<Map<String, dynamic>>()
              .map(ChatMessageModel.fromJson)
              .toList();
    pagination = json['pagination'] == null
        ? null
        : ChatPagination.fromJson(json['pagination']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (messages != null) {
      data['messages'] = messages!.map((e) => e.toJson()).toList();
    }
    if (pagination != null) data['pagination'] = pagination!.toJson();
    return data;
  }
}

class ChatUnreadResponse {
  bool? status;
  String? message;
  int? unreadCount;

  ChatUnreadResponse({this.status, this.message, this.unreadCount});

  ChatUnreadResponse.fromJson(Map<String, dynamic> json) {
    status = _toBool(json['status']);
    message = _toStr(json['message']);
    unreadCount = _toInt(json['data']?['unread_count']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = {'unread_count': unreadCount};
    return data;
  }
}

class CreateConversationResponse {
  bool? status;
  String? message;
  ConversationModel? conversation;

  CreateConversationResponse({this.status, this.message, this.conversation});

  CreateConversationResponse.fromJson(Map<String, dynamic> json) {
    status = _toBool(json['status']);
    message = _toStr(json['message']);
    conversation = json['data']?['conversation'] == null
        ? null
        : ConversationModel.fromJson(json['data']['conversation']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (conversation != null) {
      data['data'] = {'conversation': conversation!.toJson()};
    }
    return data;
  }
}

class SendMessageResponse {
  bool? status;
  String? message;
  ChatMessageModel? chatMessage;

  SendMessageResponse({this.status, this.message, this.chatMessage});

  SendMessageResponse.fromJson(Map<String, dynamic> json) {
    status = _toBool(json['status']);
    message = _toStr(json['message']);
    chatMessage = json['data']?['message'] == null
        ? null
        : ChatMessageModel.fromJson(json['data']['message']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (chatMessage != null) {
      data['data'] = {'message': chatMessage!.toJson()};
    }
    return data;
  }
}

class DeletedMessageResponse {
  bool? status;
  String? message;
  ChatMessageModel? chatMessage;

  DeletedMessageResponse({this.status, this.message, this.chatMessage});

  DeletedMessageResponse.fromJson(Map<String, dynamic> json) {
    status = _toBool(json['status']);
    message = _toStr(json['message']);
    chatMessage = json['data']?['message'] == null
        ? null
        : ChatMessageModel.fromJson(json['data']['message']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (chatMessage != null) {
      data['data'] = {'message': chatMessage!.toJson()};
    }
    return data;
  }
}
