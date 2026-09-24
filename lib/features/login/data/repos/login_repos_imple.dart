import 'dart:convert';

import 'package:by3ly/core/errors/failure.dart';
  import 'package:by3ly/features/login/data/models/login_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
 import '../../../../core/app_services/remote_services/end_points.dart';
import '../../../../core/errors/error_handler.dart';
import 'login_repos.dart';


class LoginRepoImpl implements LoginRepo {
  final ApiService? apiService;

  LoginRepoImpl(this.apiService);


  @override
  Future<Either<Failure, LoginModel>> login({required String phone , required String password , required String deviceToken}) async{
    try {
      var data = json.encode({
        "phone": phone,
        "password": password,
        "device_token": deviceToken,
      });
      var response = await apiService!.postData(
        endPoint: EndPoints.login,
        data: data,
      );
      LoginModel result = LoginModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      return left(handleError(e));
    }
  }


}

