import 'package:by3ly/core/errors/failure.dart';
  import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/notifications_model.dart';
import 'notifications_repos.dart';



class NotificationsDataRepoImpl implements NotificationsRepos {
  final ApiService? apiService;

  NotificationsDataRepoImpl(this.apiService);


  @override
  Future<Either<Failure, NotificationsModel>> getNotificationsData({
    required String type,
}) async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.notifications,
        
        query: {
         "type" : type,
        },
      );
      NotificationsModel result = NotificationsModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
