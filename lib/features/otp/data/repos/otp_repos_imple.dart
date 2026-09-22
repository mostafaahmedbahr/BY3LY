import 'dart:convert';

import 'package:dartz/dartz.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../models/otp_model.dart';
import '../models/resend_otp_model.dart';
import 'otp_repos.dart';


class OtpReposImpl implements OtpRepos {
  final ApiService? apiService;

  OtpReposImpl(this.apiService);


  @override
  Future<Either<Failure, OtpModel>> verifyOtp({
    required String otp, required String email,
}) async{
    try {
      var data = json.encode({
        "email": email,
        "otp": otp
      });
      var response = await apiService!.postData(
        endPoint: EndPoints.verifyCode,
        data: data,
      );
      OtpModel result = OtpModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      return left(handleError(e));
    }
  }


  @override
  Future<Either<Failure, ResendOtpModel>> resendOtp({
    required String email,
  }) async{
    try {
      var response = await apiService!.postData(
        endPoint: EndPoints.resendCode,
        data: {
          "email" : email,
        },
      );
      ResendOtpModel result = ResendOtpModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      return left(handleError(e));
    }
  }
}
