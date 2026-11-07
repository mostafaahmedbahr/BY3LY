import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import 'package:by3ly/features/legalContent/data/models/legal_content_model.dart';

abstract class LegalContentRepos {
  Future<Either<Failure, LegalContentModel>> getLegalContent(
    LegalContentType type,
  );
}
