import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/chooseLocation/data/models/choose_location_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/cities_centers_model.dart';
import 'choose_location_repos.dart';


class ChooseLocationReposImpl implements ChooseLocationRepos {
  final ApiService? apiService;

  ChooseLocationReposImpl(this.apiService);


  @override
  Future<Either<Failure, AllCitiesAndCentersModel>> getAllCitiesAndCentersData()
  async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.getCities,
      );
      AllCitiesAndCentersModel result = AllCitiesAndCentersModel.fromJson(response.data);
      debugPrint("ChooseLocationReposImpl getAllCitiesAndCentersData");
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
  Future<Either<Failure, ChooseLocationModel>> chooseLocationCityAndCenter({
    required String cityId, required String centerId})async{
    try {
      var response = await apiService!.postData(
        
        endPoint: EndPoints.addLocation,
        data: {
          "city_id" : cityId,
          "center_id" : centerId,
        },
      );
      ChooseLocationModel result = ChooseLocationModel.fromJson(response.data);
      debugPrint("ChooseLocationReposImpl chooseLocationCityAndCenter");
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
