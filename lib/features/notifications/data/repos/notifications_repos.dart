import 'package:by3ly/core/errors/failure.dart';
 import 'package:dartz/dartz.dart';

import '../../../../core/general_models/general_model.dart';
import '../models/notifications_model.dart';

abstract class NotificationsRepos{

  Future<Either<Failure , NotificationsModel>> getNotificationsData({
    required String type,
    int page = 1,
    int perPage = 15,
  });

  Future<Either<Failure , GeneralModel>> markNotificationRead({
    required String notificationId,
  });

  Future<Either<Failure , GeneralModel>> markAllNotificationsRead();

  Future<Either<Failure , GeneralModel>> deleteNotification({
    required String notificationId,
  });

  Future<Either<Failure , GeneralModel>> deleteAllNotifications();

}
