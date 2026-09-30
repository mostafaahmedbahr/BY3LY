import 'package:by3ly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/compare_model.dart';
import 'compare_repos.dart';

class CompareReposImpl implements CompareRepos {
  final ApiService? apiService;

  CompareReposImpl(this.apiService);

  @override
  Future<Either<Failure, CompareModel>> compareProducts({
    required List<int> productIds,
  }) async {
    try {
      var response = await apiService!.postData(
        endPoint: EndPoints.compareProducts,
        data: {
          "product_ids": productIds,
        },
      );
      CompareModel result = CompareModel.fromJson(response.data);
      debugPrint('CompareReposImpl compareProducts: status=${result.status}');
      return right(result);
    } catch (e, s) {
      debugPrint('CompareReposImpl compareProducts error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
