import 'package:by3ly/core/errors/failure.dart';
  import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/general_models/general_model.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/fav_model.dart';
import 'fav_repos.dart';


class FavDataRepoImpl implements FavRepos {
  final ApiService? apiService;

  FavDataRepoImpl(this.apiService);


  @override
  Future<Either<Failure, FavDataModel>> getFavData() async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.getFavourites,
        
      );
      FavDataModel result = FavDataModel.fromJson(response.data);
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
  Future<Either<Failure, GeneralModel>> removeProductFromFav(
      {required int productId}
      ) async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.addFavourite,
        
        query: {
          "product_id" : productId,
        },
      );
      GeneralModel result = GeneralModel.fromJson(response.data);
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
