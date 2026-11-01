import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/statistics_model.dart';

abstract class StatisticsRepos {
  /// Fetches the seller statistics.
  ///
  /// - [month]: `YYYY-MM` to load a whole month.
  /// - [date]: `YYYY-MM-DD` to focus a single day (period becomes that day).
  /// - [page]: page of the sales list returned by the backend.
  Future<Either<Failure, StatisticsModel>> getStatistics({
    String? month,
    String? date,
    int page = 1,
  });
}
