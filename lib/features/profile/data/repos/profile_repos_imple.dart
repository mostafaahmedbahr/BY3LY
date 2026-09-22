import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/profile/data/models/logout_model.dart';
import 'package:by3ly/features/profile/data/repos/profile_repos.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../../../deleteAccount/data/models/delete_account_model.dart';
import '../models/profile_data_model.dart';


class ProfileRepoImpl implements ProfileRepos {
  final ApiService? apiService;

  ProfileRepoImpl(this.apiService);


  @override
  Future<Either<Failure, ProfileModel>> getProfileData() async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.getProfileData,
      );
      ProfileModel result = ProfileModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, LogoutModel>> logout() async{
    try {
      var response = await apiService!.postData(
          endPoint: EndPoints.logout,
          
      );
      LogoutModel result = LogoutModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, DeleteAccountModel>> deleteAccount() async{
    try {
      var response = await apiService!.postData(
          endPoint: EndPoints.deleteAccount,
          
      );
      DeleteAccountModel result = DeleteAccountModel.fromJson(response.data);
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


