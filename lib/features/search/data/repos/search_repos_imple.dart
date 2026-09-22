import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/allCategories/data/models/all_categoies_model.dart';
import 'package:by3ly/features/allCategories/data/repositories/all_categories_repo.dart';
import 'package:by3ly/features/search/data/repos/search_repos.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/all_products_search_model.dart';


class SearchReposImpl implements SearchRepos {
  final ApiService? apiService;

  SearchReposImpl(this.apiService);


  @override
  Future<Either<Failure, AllProductsSearchModel>> getAllProductsForSearch() async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.searchProducts,
      );
      AllProductsSearchModel result = AllProductsSearchModel.fromJson(response.data);
      print(response.data);
      print("SearchReposImpl getAllProductsForSearch");
      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
