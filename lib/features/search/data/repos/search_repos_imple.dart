import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/search/data/repos/search_repos.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/all_products_search_model.dart';


class SearchReposImpl implements SearchRepos {
  final ApiService? apiService;

  SearchReposImpl(this.apiService);


  @override
  Future<Either<Failure, AllProductsSearchModel>> getAllProductsForSearch({int page = 1}) async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.products,
        query: {'page': page},
      );
      AllProductsSearchModel result = AllProductsSearchModel.fromJson(response.data);
      debugPrint("SearchReposImpl getAllProductsForSearch page=$page");
      return right(result);
    } catch (e, s) {
      debugPrint('SearchReposImpl getAllProductsForSearch error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
