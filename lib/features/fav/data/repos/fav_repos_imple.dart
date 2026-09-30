import 'package:by3ly/core/errors/failure.dart';
  import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
        endPoint: EndPoints.favourites,
      );
      FavDataModel result = FavDataModel.fromJson(response.data);
      debugPrint('FavDataRepoImpl getFavData: ${result.data?.favourites?.length ?? 0} items');
      return right(result);
    } catch (e, s) {
      debugPrint('FavDataRepoImpl getFavData error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, GeneralModel>> addProductToFav(
      {required int productId}
      ) async{
    try {
      var response = await apiService!.postData(
        endPoint: EndPoints.favourites,
        data: {
          "product_id" : productId,
        },
      );
      GeneralModel result = GeneralModel.fromJson(response.data);
      debugPrint('FavDataRepoImpl addProductToFav: status=${result.status} msg=${result.message}');
      return right(result);
    } catch (e, s) {
      debugPrint('FavDataRepoImpl addProductToFav error: $e');
      debugPrint(s.toString());
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
      var response = await apiService!.deleteData(
        endPoint: EndPoints.favourites,
        query: {
          "product_id" : productId,
        },
      );
      GeneralModel result = GeneralModel.fromJson(response.data);
      debugPrint('FavDataRepoImpl removeProductFromFav: status=${result.status} msg=${result.message}');
      return right(result);
    } catch (e, s) {
      debugPrint('FavDataRepoImpl removeProductFromFav error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

}
