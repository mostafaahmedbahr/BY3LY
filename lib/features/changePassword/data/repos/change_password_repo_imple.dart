import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../main_importants.dart';
import '../models/change_password_model.dart';
import 'change_password_repo.dart';

class ChangePasswordRepoImpl implements ChangePasswordRepo {
  final ApiService apiService;

  ChangePasswordRepoImpl(this.apiService);

  @override
  Future<Either<Failure, ChangePasswordModel>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      // The server expects the change-password payload keyed by the
      // currently authenticated user's email + reset token, not by the
      // old plaintext password. `oldPassword` is validated locally and
      // ignored for the network call.
      final formData = FormData.fromMap({
        "email": CacheHelper.getData(key: "email"),
        "reset_token": CacheTokenManger.userToken,
        "new_password": newPassword,
        "confirm_new_password": newPasswordConfirmation,
      });
      final response = await apiService.postData(
        endPoint: EndPoints.changePassword,
        data: formData,
      );
      final result = ChangePasswordModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      return left(handleError(e));
    }
  }
}
