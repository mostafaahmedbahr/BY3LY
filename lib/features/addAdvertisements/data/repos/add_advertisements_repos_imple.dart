import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/addAdvertisements/data/models/get_car_marka_model.dart';
import 'package:by3ly/features/addAdvertisements/data/models/get_car_models_model.dart';
import 'package:by3ly/features/addAdvertisements/data/models/get_car_types_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/add_advertisement_model.dart';
import 'add_advertisements_repos.dart';


class AddAdvertisementsRepoImpl implements AddAdvertisementsRepos {
  final ApiService? apiService;

  AddAdvertisementsRepoImpl(this.apiService);


  @override
  Future<Either<Failure, AddAdvertisementModel>> addAdvertisement({
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
}) async{
    try {
      FormData formData = FormData.fromMap({
        'name_ar': nameAr,
        'desc_ar': descAr,
        'price': price,
        'category_id': categoryId,
        'sub_category_id': subCategoryId,
        'marka_id': markaId,
        'model_id': modelId,
        'type_id': typeId,
        'lat': lat,
        'long': long,
      });
      if (images.isNotEmpty) {
        for (var image in images) {
          formData.files.add(MapEntry(
            'images[]',
            await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
          ));
        }
      }
      var response = await apiService!.postData(
        endPoint: EndPoints.addProduct,
        data: formData,

      );
      AddAdvertisementModel result = AddAdvertisementModel.fromJson(response.data);
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
  Future<Either<Failure, GetCarMarkaModel>> getCarsMarka() async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.marka,
      );
      GetCarMarkaModel result = GetCarMarkaModel.fromJson(response.data);
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
  Future<Either<Failure, GetCarModelsModel>> getCarsModels() async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.models,
      );
      GetCarModelsModel result = GetCarModelsModel.fromJson(response.data);
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
  Future<Either<Failure, GetCarTypesModel>> getCarsTypes() async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.typies,
      );
      GetCarTypesModel result = GetCarTypesModel.fromJson(response.data);
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
