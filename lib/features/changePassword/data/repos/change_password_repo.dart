import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../models/change_password_model.dart';

abstract class ChangePasswordRepo {
  Future<Either<Failure, ChangePasswordModel>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
    required String screenName,
  });
}
