import 'package:dartz/dartz.dart';

import '../errors/failure.dart';

abstract class UseCaseWithParam<T, Param> {
  Future<Either<Failure, T>> call(Param param);
}
