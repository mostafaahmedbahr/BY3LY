import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/compare_model.dart';

abstract class CompareRepos {
  Future<Either<Failure, CompareModel>> compareProducts({
    required List<int> productIds,
  });
}
