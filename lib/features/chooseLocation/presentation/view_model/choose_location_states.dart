import 'package:by3ly/features/chooseLocation/data/models/choose_location_model.dart';

import '../../data/models/cities_centers_model.dart';

abstract class ChooseLocationStates{}

class ChooseLocationInitState extends ChooseLocationStates{}

class ChooseLocationUpdateState extends ChooseLocationStates{}

class GetAllCitiesAndCentersLoading extends ChooseLocationStates {}

class GetAllCitiesAndCentersSuccess extends ChooseLocationStates {
  final AllCitiesAndCentersModel allCitiesAndCentersModel;
  GetAllCitiesAndCentersSuccess(this.allCitiesAndCentersModel);
}

class GetAllCitiesAndCentersError extends ChooseLocationStates {
  final String message;
  GetAllCitiesAndCentersError(this.message);
}

class CentersFilteredSuccessState extends ChooseLocationStates{}

class AddLocationCitiesAndCentersLoading extends ChooseLocationStates {}

class AddLocationCitiesAndCentersSuccess extends ChooseLocationStates {
  final ChooseLocationModel chooseLocationModel;
  AddLocationCitiesAndCentersSuccess(this.chooseLocationModel);
}

class AddLocationCitiesAndCentersError extends ChooseLocationStates {
  final String message;
  AddLocationCitiesAndCentersError(this.message);
}

class ResetCenterState extends ChooseLocationStates {}