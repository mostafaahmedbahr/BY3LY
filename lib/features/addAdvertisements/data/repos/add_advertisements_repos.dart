import 'package:by3ly/features/addAdvertisements/data/models/get_car_marka_model.dart';
import 'package:by3ly/features/addAdvertisements/data/models/get_car_models_model.dart';
import 'package:by3ly/features/addAdvertisements/data/models/get_car_types_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../models/add_advertisement_model.dart';

abstract class AddAdvertisementsRepos{

  Future<Either<Failure,AddAdvertisementModel>> addAdvertisement({
    required String nameAr,
    required String descAr,
    required String price,
    required int categoryId,
    required int subCategoryId,
    required int markaId,
    required int modelId,
    required int typeId,
    required double lat,
    required double long,
    required int communication,
    required int negotiable,
    required String phone,
    required dynamic images,
});

  Future<Either<Failure,GetCarMarkaModel>> getCarsMarka();
  Future<Either<Failure,GetCarModelsModel>> getCarsModels();
  Future<Either<Failure,GetCarTypesModel>> getCarsTypes();


}