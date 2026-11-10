import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:by3ly/core/app_services/remote_services/api_service.dart';
import 'package:by3ly/core/app_services/remote_services/end_points.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/updateProfile/data/repos/update_profile_data_repo.dart';
import 'package:by3ly/features/updateProfile/data/models/update_profile_data_model.dart';

class UpdateProfileDataRepoImpl implements UpdateProfileDataRepos {
  final ApiService? apiService;

  UpdateProfileDataRepoImpl(this.apiService);

  @override
  Future<Either<Failure, UpdateProfileDataModel>> updateProfileData(
      {required dynamic data}) async {
    try {
      var response = await apiService!.postData(
        endPoint: EndPoints.updateProfile,
        isMultipart: true,
        data: data,
      );
      UpdateProfileDataModel result =
          UpdateProfileDataModel.fromJson(response.data);
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
