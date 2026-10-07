import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/general_models/general_model.dart';
import '../models/packages_model.dart';
import '../models/subscribe_package_model.dart';

abstract class PackagesRepos {
  Future<Either<Failure, PackagesModel>> getPackages();

  Future<Either<Failure, SubscribePackageModel>> subscribe({
    required int packageId,
  });
}
