import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/chat_models.dart';

abstract class ChatRepository {
  Future<Either<Failure, ConversationsResponse>> getConversations({
    int page = 1,
    int perPage = 15,
  });

  Future<Either<Failure, ChatUnreadResponse>> getUnreadCount();

  Future<Either<Failure, ChatMessagesResponse>> getMessages({
    required int conversationId,
    int? beforeId,
    int? afterId,
    int page = 1,
    int perPage = 30,
  });

  Future<Either<Failure, CreateConversationResponse>> createConversation({
    int? productId,
    int? userId,
    String? body,
  });

  Future<Either<Failure, SendMessageResponse>> sendTextMessage({
    required int conversationId,
    required String body,
  });

  Future<Either<Failure, SendMessageResponse>> sendImageMessage({
    required int conversationId,
    required String imagePath,
  });

  Future<Either<Failure, ChatUnreadResponse>> markConversationRead({
    required int conversationId,
  });

  Future<Either<Failure, DeletedMessageResponse>> deleteMessage({
    required int conversationId,
    required int messageId,
  });

  Future<Either<Failure, ChatUnreadResponse>> deleteConversation({
    required int conversationId,
  });
}
