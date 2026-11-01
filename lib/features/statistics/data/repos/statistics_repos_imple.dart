import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../../../../core/errors/failure.dart';
import '../models/statistics_model.dart';
import 'statistics_repos.dart';

class StatisticsRepoImpl implements StatisticsRepos {
  final ApiService? apiService;

  StatisticsRepoImpl(this.apiService);

  @override
  Future<Either<Failure, StatisticsModel>> getStatistics({
    String? month,
    String? date,
    int page = 1,
  }) async {
    try {
      final query = <String, dynamic>{"page": page};
      if (month != null && month.isNotEmpty) query["month"] = month;
      if (date != null && date.isNotEmpty) query["date"] = date;

      final response = await apiService!.getData(
        endPoint: EndPoints.statistics,
        query: query,
      );
      final result = StatisticsModel.fromJson(response.data);
      debugPrint(
        'StatisticsRepo get: month=${result.data?.month} '
        'days=${(result.data?.days ?? []).length} '
        'sales=${(result.data?.sales ?? []).length}',
      );
      return right(result);
    } catch (e, s) {
      debugPrint('StatisticsRepo get error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
