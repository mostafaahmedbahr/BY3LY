import 'package:by3ly/core/errors/failure.dart';
 import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';

import '../models/all_sub_categories_products_model.dart';
import 'all_sub_categories_products_repos.dart';


class AllSubCategoriesProductsReposImpl implements AllSubCategoriesProductsRepos {
  final ApiService? apiService;

  AllSubCategoriesProductsReposImpl(this.apiService);


  @override
  Future<Either<Failure, AllSubCategoriesProductsModel>> getAllSubCategoriesProductsData({
    required int subCategoryId,
}) async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.productBySubCategory,
        
        query: {
          "sub_category_id" : subCategoryId,
        },
      );
      AllSubCategoriesProductsModel result = AllSubCategoriesProductsModel.fromJson(response.data);
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
