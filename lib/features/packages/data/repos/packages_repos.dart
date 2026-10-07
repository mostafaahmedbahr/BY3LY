import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/general_models/general_model.dart';
import '../models/packages_model.dart';

abstract class PackagesRepos {
  Future<Either<Failure, PackagesModel>> getPackages();

  Future<Either<Failure, GeneralModel>> subscribe({
    required int packageId,
  });
}
