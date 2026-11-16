abstract class HelpSupportChatStates {}

class HelpSupportChatInitState extends HelpSupportChatStates {}

class SupportChatConversationLoading extends HelpSupportChatStates {}

class SupportChatMessagesLoading extends HelpSupportChatStates {}

class SupportChatMessagesSuccess extends HelpSupportChatStates {}

class SupportChatMessagesError extends HelpSupportChatStates {
  final String message;
  SupportChatMessagesError(this.message);
}

class SupportChatLoadingOlderMessages extends HelpSupportChatStates {}

class SupportChatOlderMessagesError extends HelpSupportChatStates {
  final String message;
  SupportChatOlderMessagesError(this.message);
}

class SupportChatReceivingNewMessages extends HelpSupportChatStates {}

class SupportChatMessageSending extends HelpSupportChatStates {}

class SupportChatImageSending extends HelpSupportChatStates {}

class SupportChatMessageSent extends HelpSupportChatStates {}

class SupportChatMessageSendError extends HelpSupportChatStates {
  final String message;
  SupportChatMessageSendError(this.message);
}

class SupportChatMarkedRead extends HelpSupportChatStates {}
