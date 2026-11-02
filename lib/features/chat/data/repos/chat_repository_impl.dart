import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../../../../core/errors/failure.dart';
import '../models/chat_models.dart';
import 'chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this.apiService);

  final ApiService? apiService;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() body) async {
    try {
      return right(await body());
    } catch (e, stack) {
      debugPrint('ChatRepository error: $e');
      debugPrint(stack.toString());
      if (e is DioException) {
        // The chat endpoints return validation errors at the top level
        // (`{status, number, message, errors}`) instead of inside `data`, so
        // read them here before falling back to the global mapper.
        final validationMessage = _validationMessage(e);
        if (validationMessage != null) {
          return left(ServerFailure(validationMessage));
        }
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  String? _validationMessage(DioException exception) {
    if (exception.response?.statusCode != 422) return null;
    final data = exception.response?.data;
    if (data is! Map) return null;

    final errors = data['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final firstError = errors.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
      if (firstError != null) return firstError.toString();
    }

    final message = data['message'];
    return message?.toString();
  }

  @override
  Future<Either<Failure, ConversationsResponse>> getConversations({
    int page = 1,
    int perPage = 15,
  }) {
    return _guard(() async {
      final response = await apiService!.getData(
        endPoint: EndPoints.conversations,
        query: {'page': page, 'per_page': perPage},
      );
      return ConversationsResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, ChatUnreadResponse>> getUnreadCount() {
    return _guard(() async {
      final response = await apiService!.getData(
        endPoint: EndPoints.conversationsUnreadCount,
      );
      return ChatUnreadResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, ChatMessagesResponse>> getMessages({
    required int conversationId,
    int? beforeId,
    int? afterId,
    int page = 1,
    int perPage = 30,
  }) {
    return _guard(() async {
      final query = <String, dynamic>{'page': page, 'per_page': perPage};
      if (beforeId != null) query['before_id'] = beforeId;
      if (afterId != null) query['after_id'] = afterId;
      final response = await apiService!.getData(
        endPoint: EndPoints.conversationMessages(conversationId),
        query: query,
      );
      return ChatMessagesResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, CreateConversationResponse>> createConversation({
    int? productId,
    int? userId,
    String? body,
  }) {
    return _guard(() async {
      final payload = <String, dynamic>{};
      if (productId != null) payload['product_id'] = productId;
      if (userId != null) payload['user_id'] = userId;
      if (body != null && body.trim().isNotEmpty) payload['body'] = body.trim();
      final response = await apiService!.postData(
        endPoint: EndPoints.conversations,
        data: payload,
      );
      return CreateConversationResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, SendMessageResponse>> sendTextMessage({
    required int conversationId,
    required String body,
  }) {
    return _guard(() async {
      final response = await apiService!.postData(
        endPoint: EndPoints.conversationMessages(conversationId),
        data: {'body': body},
      );
      return SendMessageResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, SendMessageResponse>> sendImageMessage({
    required int conversationId,
    required String imagePath,
  }) {
    return _guard(() async {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split(RegExp(r'[\\/]')).last,
        ),
      });
      final response = await apiService!.postData(
        endPoint: EndPoints.conversationMessages(conversationId),
        data: formData,
        isMultipart: true,
      );
      return SendMessageResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, ChatUnreadResponse>> markConversationRead({
    required int conversationId,
  }) {
    return _guard(() async {
      final response = await apiService!.patchData(
        endPoint: EndPoints.conversationRead(conversationId),
      );
      return ChatUnreadResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, DeletedMessageResponse>> deleteMessage({
    required int conversationId,
    required int messageId,
  }) {
    return _guard(() async {
      final response = await apiService!.deleteData(
        endPoint: EndPoints.conversationMessage(conversationId, messageId),
      );
      return DeletedMessageResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, ChatUnreadResponse>> deleteConversation({
    required int conversationId,
  }) {
    return _guard(() async {
      final response = await apiService!.deleteData(
        endPoint: EndPoints.conversationById(conversationId),
      );
      return ChatUnreadResponse.fromJson(response.data);
    });
  }
}
