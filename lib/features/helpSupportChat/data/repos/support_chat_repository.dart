import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/support_models.dart';

abstract class SupportChatRepository {
  /// GET /api/support/conversation — get/create the current user's thread.
  Future<Either<Failure, SupportConversationResponse>> getConversation();

  /// GET /api/support/unread-count — unread staff replies count.
  Future<Either<Failure, SupportUnreadResponse>> getUnreadCount();

  /// GET /api/support/messages — newest first, `before_id`/`after_id` for
  /// paging. Loading history marks staff replies as read server-side.
  Future<Either<Failure, SupportMessagesResponse>> getMessages({
    int? beforeId,
    int? afterId,
    int page = 1,
    int perPage = 30,
  });

  /// POST /api/support/messages with `{ "body": body }`.
  Future<Either<Failure, SendSupportMessageResponse>> sendTextMessage({
    required String body,
  });

  /// POST /api/support/messages as multipart with an `image` file
  /// (jpeg/png/webp, max 5 MB) and optional `body`.
  Future<Either<Failure, SendSupportMessageResponse>> sendImageMessage({
    required String imagePath,
    String? body,
  });

  /// PATCH /api/support/read — mark staff replies as read.
  Future<Either<Failure, SupportReadResponse>> markRead();
}
