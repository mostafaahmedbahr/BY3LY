import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/home/data/models/add_remove_product_to_fav_model.dart';
import 'package:by3ly/features/home/data/models/home_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import 'home_repo.dart';


class HomeRepoImpl implements HomeRepo {
  final ApiService? apiService;

  HomeRepoImpl(this.apiService);


  @override
  Future<Either<Failure, HomeModel>> getHomeData()async {
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.home,
        
      );
      HomeModel result = HomeModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, AddRemoveProductToFavModel>> addRemoveProductToFav({
    required int productId,
})async {
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.addFavourite,
        
        query: {
          "product_id" : productId,
        },
      );
      AddRemoveProductToFavModel result = AddRemoveProductToFavModel.fromJson(response.data);
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
