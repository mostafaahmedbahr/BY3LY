import 'package:by3ly/core/app_services/remote_services/api_service.dart';
import 'package:by3ly/core/app_services/remote_services/end_points.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/chooseLocation/data/models/choose_location_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../models/cities_centers_model.dart';
import 'choose_location_repos.dart';

class ChooseLocationReposImpl implements ChooseLocationRepos {
  final ApiService apiService;

  ChooseLocationReposImpl(this.apiService);

  @override
  Future<Either<Failure, AllCitiesAndCentersModel>>
      getAllCitiesAndCentersData() async {
    try {
      final response = await apiService.getData(
        endPoint: EndPoints.getCities,
      );
      final result = AllCitiesAndCentersModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChooseLocationModel>>
      chooseLocationCityAndCenter({
    required int cityId,
    required int centerId,
  }) async {
    try {
      final response = await apiService.postData(
        endPoint: EndPoints.addLocation,
        data: {
          'city_id': cityId,
          'center_id': centerId,
        },
      );
      final result = ChooseLocationModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
