import 'package:dartz/dartz.dart';

import '../errors/failure.dart';


abstract class UseCaseWithParam<Type , Param>
{
  Future<Either< Failure, Type>> call(Param param);
}