import 'package:by3ly/core/errors/failure.dart';
 import 'package:dartz/dartz.dart';

import '../models/update_profile_data_model.dart';


abstract class UpdateProfileDataRepos{


  Future<Either<Failure , UpdateProfileDataModel>> updateProfileData({required dynamic data});


}