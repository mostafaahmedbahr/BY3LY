import 'package:by3ly/core/general_models/general_model.dart';
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

  /// New unified create-ad endpoint.
  Future<Either<Failure,GeneralModel>> addNewAd({    required String name,
    required String description,
    required String price,
    String? discount,
    required int isNegotiable,
    required int isUrgent,
    required int categoryId,
    required int subCategoryId,
    required String shippingType,
    required String condition,
    required int cityId,
    required int centerId,
    required List<dynamic> images,
    required String paymentMethod,
    String? receiptPath,
  });

  /// Edit an existing ad (same fields + ad_id, new image files only).
  Future<Either<Failure,GeneralModel>> editAd({
    required int adId,
    required String name,
    required String description,
    required String price,
    String? discount,
    required int isNegotiable,
    required int isUrgent,
    required int categoryId,
    required int subCategoryId,
    required String shippingType,
    required String condition,
    required int cityId,
    required int centerId,
    required List<dynamic> images,
  });


}