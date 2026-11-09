import 'package:by3ly/core/app_services/remote_services/api_service.dart';
import 'package:by3ly/core/app_services/remote_services/end_points.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/all_sub_categories_model.dart';
import 'all_sub_categories_repos.dart';

class AllSubCategoriesRepoImpl implements AllSubCategoriesRepos {
  final ApiService? apiService;

  AllSubCategoriesRepoImpl(this.apiService);

  @override
  Future<Either<Failure, AllSubCategoriesModel>>
      getAllSubCategoriesData({required int categoryId}) async {
    try {
      final response = await apiService!.getData(
        endPoint: EndPoints.getSubCategories,
        query: {
          'category_id': categoryId,
        },
      );
      final result = AllSubCategoriesModel.fromJson(response.data);
      debugPrint(
        'AllSubCategoriesRepoImpl getAllSubCategoriesData categoryId=$categoryId subs=${result.data?.subCategories?.length ?? 0}',
      );
      return right(result);
    } catch (e, s) {
      debugPrint('AllSubCategoriesRepoImpl error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
