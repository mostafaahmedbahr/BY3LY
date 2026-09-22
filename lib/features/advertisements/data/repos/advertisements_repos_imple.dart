import 'package:by3ly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/my_ads_data_model.dart';
import 'advertisements_repos.dart';


class AdvertisementsRepoImpl implements AdvertisementsRepo {
  final ApiService? apiService;

  AdvertisementsRepoImpl(this.apiService);


  @override
  Future<Either<Failure, MyAdsDataModel>> getMyAdsData({
    required int type,
}) async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.myAds,
        
        query: {
          "type" : type,
        },
      );
      MyAdsDataModel result = MyAdsDataModel.fromJson(response.data);
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
