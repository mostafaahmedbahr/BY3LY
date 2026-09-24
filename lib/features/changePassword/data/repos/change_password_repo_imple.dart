import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../models/change_password_model.dart';
import 'change_password_repo.dart';
import '../../../../main_importants.dart';

class ChangePasswordRepoImpl implements ChangePasswordRepo {
  final ApiService? apiService;

  ChangePasswordRepoImpl(this.apiService);

  @override
  Future<Either<Failure, ChangePasswordModel>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
    required String screenName,
  }) async {
    try {
      var forgetPasswordFormData = FormData.fromMap({
        "email": CacheHelper.getData(key: "email"),
        "otp": CacheHelper.getData(key: "otp"),
        "password": newPassword,
        "password_confirmation": newPasswordConfirmation,
      });
      var changePasswordFormData = FormData.fromMap({
        "email": CacheHelper.getData(key: "email"),
        "reset_token": CacheTokenManger.userToken,
        "new_password": newPassword,
        "confirm_new_password": newPasswordConfirmation,
      });
      var response = await apiService!.postData(
        endPoint: screenName == "ForgetPasswordView"
            ? EndPoints.resetPassword
            : EndPoints.changePassword,
        data: screenName == "ForgetPasswordView"
            ? forgetPasswordFormData
            : changePasswordFormData,
      );
      ChangePasswordModel result = ChangePasswordModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      return left(handleError(e));
    }
  }
}
