import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/general_models/general_model.dart';
import '../models/packages_model.dart';
import 'packages_repos.dart';

class PackagesRepoImpl implements PackagesRepos {
  final ApiService? apiService;

  PackagesRepoImpl(this.apiService);

  @override
  Future<Either<Failure, PackagesModel>> getPackages() async {
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.subscriptionPackages,
      );
      PackagesModel result = PackagesModel.fromJson(response.data);
      debugPrint(
          'PackagesRepo get: ${(result.data?.packages ?? []).length} packages');
      return right(result);
    } catch (e, s) {
      debugPrint('PackagesRepo get error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, GeneralModel>> subscribe({
    required int packageId,
  }) async {
    try {
      var response = await apiService!.postData(
        endPoint: EndPoints.subscriptions,
        data: {
          "package_id": packageId,
        },
      );
      final result = GeneralModel.fromJson(response.data);
      return right(result);
    } catch (e, s) {
      debugPrint('PackagesRepo subscribe error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
