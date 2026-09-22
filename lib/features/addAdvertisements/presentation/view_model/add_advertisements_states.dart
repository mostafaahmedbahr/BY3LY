import 'package:by3ly/features/addAdvertisements/data/models/get_car_marka_model.dart';
import 'package:by3ly/features/addAdvertisements/data/models/get_car_models_model.dart';
import 'package:by3ly/features/addAdvertisements/data/models/get_car_types_model.dart';

import '../../data/models/add_advertisement_model.dart';

abstract class AddAdvertisementsStates{}

class AddAdvertisementsInitState extends AddAdvertisementsStates{}

class AddProductAdvertisementsLoadingState extends AddAdvertisementsStates{}
class AddProductAdvertisementsSuccessState extends AddAdvertisementsStates{
  final AddAdvertisementModel addAdvertisementModel;
  AddProductAdvertisementsSuccessState(this.addAdvertisementModel);
}
class AddProductAdvertisementsErrorState extends AddAdvertisementsStates{
  final String error;
  AddProductAdvertisementsErrorState(this.error);
}

class UploadImageSuccessState extends AddAdvertisementsStates{}
class DeleteImageSuccessState extends AddAdvertisementsStates{}

class ToggleCheckboxSuccessState extends AddAdvertisementsStates{}


class GetCarsMarkaDataLoadingState extends AddAdvertisementsStates{}
class GetCarsMarkaDataSuccessState extends AddAdvertisementsStates{
  final GetCarMarkaModel getCarMarkaModel;
  GetCarsMarkaDataSuccessState(this.getCarMarkaModel);
}
class GetCarsMarkaDataErrorState extends AddAdvertisementsStates{
  final String error;
  GetCarsMarkaDataErrorState(this.error);
}

class GetCarsModelsDataLoadingState extends AddAdvertisementsStates{}
class GetCarsModelsDataSuccessState extends AddAdvertisementsStates{
  final GetCarModelsModel getCarModelsModel;
  GetCarsModelsDataSuccessState(this.getCarModelsModel);
}
class GetCarsModelsDataErrorState extends AddAdvertisementsStates{
  final String error;
  GetCarsModelsDataErrorState(this.error);
}

class GetCarsTypesDataLoadingState extends AddAdvertisementsStates{}
class GetCarsTypesDataSuccessState extends AddAdvertisementsStates{
  final GetCarTypesModel getCarTypesModel;
  GetCarsTypesDataSuccessState(this.getCarTypesModel);
}
class GetCarsTypesDataErrorState extends AddAdvertisementsStates{
  final String error;
  GetCarsTypesDataErrorState(this.error);
}

class SelectedCarMarkaSuccessState extends AddAdvertisementsStates{}
class SelectedCarModelSuccessState extends AddAdvertisementsStates{}
class SelectedCarTypeSuccessState extends AddAdvertisementsStates{}