import 'package:by3ly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../models/choose_location_model.dart';
import '../models/cities_centers_model.dart';

abstract class ChooseLocationRepos {

  Future<Either<Failure, AllCitiesAndCentersModel>> getAllCitiesAndCentersData();
  Future<Either<Failure, ChooseLocationModel>> chooseLocationCityAndCenter({
    required String cityId, required String centerId
});



}
