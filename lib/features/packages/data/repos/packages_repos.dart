import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/packages_model.dart';

abstract class PackagesRepos {
  Future<Either<Failure, PackagesModel>> getPackages();
}
