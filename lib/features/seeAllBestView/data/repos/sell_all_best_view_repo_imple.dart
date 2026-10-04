import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/seeAllBestView/data/repos/sell_all_best_view_repo.dart';
  import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import 'package:by3ly/features/seeAllBestView/data/models/sell_all_best_view_model.dart';


class SellAllBestViewRepoImpl implements SellAllBestViewRepo {
  final ApiService? apiService;

  SellAllBestViewRepoImpl(this.apiService);

  @override
  Future<Either<Failure, SellAllBestViewModel>> getAllBestViewProducts() async {
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.bestAllView,
      );
      SellAllBestViewModel result = SellAllBestViewModel.fromJson(response.data);
      debugPrint('SellAllBestViewRepo: ${(result.data?.products ?? []).length} products');
      return right(result);
    } catch (e, s) {
      debugPrint('SellAllBestViewRepo error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}

