import 'package:by3ly/features/allSubCategories/data/models/all_sub_categories_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
 import '../../../../main_importants.dart';
import 'all_sub_categories_repos.dart';



class AllSubCategoriesRepoImpl implements AllSubCategoriesRepos {
  final ApiService? apiService;

  AllSubCategoriesRepoImpl(this.apiService);

  @override
  Future<Either<Failure, AllSubCategoriesModel>> getAllSubCategoriesData
      ({required int categoryId}) async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.getSubCategories,
        query: {
          "category_id" : categoryId,
        },
      );
      AllSubCategoriesModel result = AllSubCategoriesModel.fromJson(response.data);
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
