import 'package:by3ly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../models/delete_account_model.dart';

abstract class DeleteAccountRepos{

  Future<Either<Failure , DeleteAccountModel>> deleteAccount();

}