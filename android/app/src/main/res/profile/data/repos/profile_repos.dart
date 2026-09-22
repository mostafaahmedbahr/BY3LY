import 'package:by3ly_app/core/errors/failure.dart';
import 'package:by3ly_app/features/profile/data/models/logout_model.dart';
import 'package:by3ly_app/features/profile/data/models/profile_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../deleteAccount/data/models/delete_account_model.dart';

abstract class ProfileRepos{


  Future<Either<Failure , ProfileModel>> getProfileData();
  Future<Either<Failure , LogoutModel>> logout();
  Future<Either<Failure , DeleteAccountModel>> deleteAccount();

}