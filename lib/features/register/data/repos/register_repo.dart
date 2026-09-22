import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../models/register_model.dart';

abstract class RegisterRepo{

  Future<Either<Failure,RegisterModel>> register({required dynamic data});



}