import '../../data/models/chat_models.dart';

abstract class ChatUnreadStates {}

class ChatUnreadInitState extends ChatUnreadStates {}

class ChatUnreadUpdated extends ChatUnreadStates {
  final int count;
  ChatUnreadUpdated(this.count);

  @override
  String toString() => 'ChatUnreadUpdated(count: $count)';
}

abstract class ConversationsStates {}

class ConversationsInitState extends ConversationsStates {}

class ConversationsLoading extends ConversationsStates {}

class ConversationsSuccess extends ConversationsStates {
  final ConversationsResponse response;
  ConversationsSuccess(this.response);
}

class ConversationsError extends ConversationsStates {
  final String message;
  ConversationsError(this.message);

  @override
  String toString() => 'ConversationsError(message: $message)';
}

class ConversationsPaginating extends ConversationsStates {}

class ConversationsPaginationError extends ConversationsStates {
  final String message;
  ConversationsPaginationError(this.message);
}

class ConversationsRefreshing extends ConversationsStates {}

class ConversationReadUpdated extends ConversationsStates {
  final int conversationId;
  ConversationReadUpdated(this.conversationId);
}

class ConversationDeleted extends ConversationsStates {
  final int conversationId;
  ConversationDeleted(this.conversationId);
}

class ConversationDeleteError extends ConversationsStates {
  final String message;
  ConversationDeleteError(this.message);
}

abstract class StartChatStates {}

class StartChatInitState extends StartChatStates {}

class StartChatLoading extends StartChatStates {}

class StartChatSuccess extends StartChatStates {
  final ConversationModel conversation;
  StartChatSuccess(this.conversation);
}

class StartChatError extends StartChatStates {
  final String message;
  StartChatError(this.message);
}

abstract class ChatStates {}

class ChatInitState extends ChatStates {}

class ChatMessagesLoading extends ChatStates {}

class ChatMessagesSuccess extends ChatStates {
  final List<ChatMessageModel> messages;
  ChatMessagesSuccess(this.messages);
}

class ChatMessagesError extends ChatStates {
  final String message;
  ChatMessagesError(this.message);
}

class ChatLoadingOlderMessages extends ChatStates {}

class ChatOlderMessagesError extends ChatStates {
  final String message;
  ChatOlderMessagesError(this.message);
}

class ChatReceivingNewMessages extends ChatStates {
  final List<ChatMessageModel> messages;
  ChatReceivingNewMessages(this.messages);
}

class ChatMessageSending extends ChatStates {}

class ChatMessageSent extends ChatStates {
  final ChatMessageModel message;
  ChatMessageSent(this.message);
}

class ChatMessageSendError extends ChatStates {
  final String message;
  ChatMessageSendError(this.message);
}

class ChatImageSending extends ChatStates {}

class ChatMessageDeleting extends ChatStates {
  final int messageId;
  ChatMessageDeleting(this.messageId);
}

class ChatMessageDeleted extends ChatStates {
  final int messageId;
  ChatMessageDeleted(this.messageId);
}

class ChatMessageDeleteError extends ChatStates {
  final String message;
  ChatMessageDeleteError(this.message);
}

class ChatConversationDeleting extends ChatStates {}

class ChatConversationDeleted extends ChatStates {}

class ChatConversationDeleteError extends ChatStates {
  final String message;
  ChatConversationDeleteError(this.message);
}

class ChatMarkedRead extends ChatStates {
  final int unreadCount;
  ChatMarkedRead(this.unreadCount);
}
