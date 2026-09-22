import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/login/data/models/login_model.dart';
import 'package:dartz/dartz.dart';

abstract class LoginRepo{

  Future<Either<Failure , LoginModel>> login({required dynamic data});

}

