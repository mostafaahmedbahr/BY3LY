import 'package:by3ly/core/errors/failure.dart';
  import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../../../../core/general_models/general_model.dart';
import '../models/notifications_model.dart';
import 'notifications_repos.dart';



class NotificationsDataRepoImpl implements NotificationsRepos {
  final ApiService? apiService;

  NotificationsDataRepoImpl(this.apiService);


  @override
  Future<Either<Failure, NotificationsModel>> getNotificationsData({
    required String type,
    int page = 1,
    int perPage = 15,
}) async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.notifications,

        query: {
         "type" : type,
         "page" : page,
         "per_page" : perPage,
        },
      );
      NotificationsModel result = NotificationsModel.fromJson(response.data);
      debugPrint('NotificationsRepo get: ${(result.data?.notifications ?? []).length} items, unread=${result.data?.unreadCount}');
      return right(result);
    } catch (e, s) {
      debugPrint('NotificationsRepo get error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, GeneralModel>> markNotificationRead({
    required String notificationId,
  }) async {
    try {
      var response = await apiService!.patchData(
        endPoint: EndPoints.notificationRead(notificationId),
      );
      final result = GeneralModel.fromJson(response.data);
      return right(result);
    } catch (e, s) {
      debugPrint('NotificationsRepo markRead error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, GeneralModel>> markAllNotificationsRead() async {
    try {
      var response = await apiService!.patchData(
        endPoint: EndPoints.notificationsReadAll,
      );
      final result = GeneralModel.fromJson(response.data);
      return right(result);
    } catch (e, s) {
      debugPrint('NotificationsRepo markAllRead error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, GeneralModel>> deleteNotification({
    required String notificationId,
  }) async {
    try {
      var response = await apiService!.deleteData(
        endPoint: EndPoints.notificationById(notificationId),
      );
      final result = GeneralModel.fromJson(response.data);
      return right(result);
    } catch (e, s) {
      debugPrint('NotificationsRepo deleteOne error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, GeneralModel>> deleteAllNotifications() async {
    try {
      var response = await apiService!.deleteData(
        endPoint: EndPoints.notifications,
      );
      final result = GeneralModel.fromJson(response.data);
      return right(result);
    } catch (e, s) {
      debugPrint('NotificationsRepo deleteAll error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
