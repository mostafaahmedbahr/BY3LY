import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/allCategories/data/models/all_categoies_model.dart';
import 'package:by3ly/features/allCategories/data/repositories/all_categories_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';


class AllCategoriesRepoImpl implements AllCategoriesRepo {
  final ApiService? apiService;

  AllCategoriesRepoImpl(this.apiService);


  @override
  Future<Either<Failure, AllCategoriesModel>> getAllCategories() async{
    try {
      var response = await apiService!.getData(
          endPoint: EndPoints.viewAllCategories,
        );
      AllCategoriesModel result = AllCategoriesModel.fromJson(response.data);
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
