import 'package:dartz/dartz.dart';

import '../errors/failure.dart';


abstract class UseCaseWithNoParam<Type>
{
  Future<Either< Failure, Type>> call();
}