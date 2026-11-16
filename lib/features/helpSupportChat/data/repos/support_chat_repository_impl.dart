import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../../../../core/errors/failure.dart';
import '../models/support_models.dart';
import 'support_chat_repository.dart';

Map<String, dynamic> _mapOf(dynamic data) {
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  return const {};
}

class SupportChatRepositoryImpl implements SupportChatRepository {
  SupportChatRepositoryImpl(this.apiService);

  final ApiService? apiService;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() body) async {
    try {
      return right(await body());
    } catch (e, stack) {
      debugPrint('SupportChatRepository error: $e');
      debugPrint(stack.toString());
      if (e is DioException) {
        // The support endpoints return validation errors at the top level
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
  Future<Either<Failure, SupportConversationResponse>> getConversation() {
    return _guard(() async {
      final response = await apiService!.getData(
        endPoint: EndPoints.supportConversation,
      );
      return SupportConversationResponse.fromJson(_mapOf(response.data));
    });
  }

  @override
  Future<Either<Failure, SupportUnreadResponse>> getUnreadCount() {
    return _guard(() async {
      final response = await apiService!.getData(
        endPoint: EndPoints.supportUnreadCount,
      );
      return SupportUnreadResponse.fromJson(_mapOf(response.data));
    });
  }

  @override
  Future<Either<Failure, SupportMessagesResponse>> getMessages({
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
        endPoint: EndPoints.supportMessages,
        query: query,
      );
      return SupportMessagesResponse.fromJson(_mapOf(response.data));
    });
  }

  @override
  Future<Either<Failure, SendSupportMessageResponse>> sendTextMessage({
    required String body,
  }) {
    return _guard(() async {
      final response = await apiService!.postData(
        endPoint: EndPoints.supportMessages,
        data: {'body': body},
      );
      return SendSupportMessageResponse.fromJson(_mapOf(response.data));
    });
  }

  @override
  Future<Either<Failure, SendSupportMessageResponse>> sendImageMessage({
    required String imagePath,
    String? body,
  }) {
    return _guard(() async {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split(RegExp(r'[\\/]')).last,
        ),
        if (body != null && body.trim().isNotEmpty) 'body': body.trim(),
      });
      final response = await apiService!.postData(
        endPoint: EndPoints.supportMessages,
        data: formData,
        isMultipart: true,
      );
      return SendSupportMessageResponse.fromJson(_mapOf(response.data));
    });
  }

  @override
  Future<Either<Failure, SupportReadResponse>> markRead() {
    return _guard(() async {
      final response = await apiService!.patchData(
        endPoint: EndPoints.supportRead,
      );
      return SupportReadResponse.fromJson(_mapOf(response.data));
    });
  }
}
