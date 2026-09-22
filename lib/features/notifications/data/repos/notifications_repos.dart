import 'package:by3ly/core/errors/failure.dart';
 import 'package:dartz/dartz.dart';

import '../models/notifications_model.dart';

abstract class NotificationsRepos{

  Future<Either<Failure , NotificationsModel>> getNotificationsData({  required String type,});

}