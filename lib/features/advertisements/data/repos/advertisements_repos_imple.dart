import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/my_ads_data_model.dart';
import '../models/pause_resume_ad_model.dart';
import 'advertisements_repos.dart';

class AdvertisementsRepoImpl implements AdvertisementsRepo {
  final ApiService? apiService;

  AdvertisementsRepoImpl(this.apiService);

  @override
  Future<Either<Failure, MyAdsDataModel>> getMyAdsData() async {
    try {
      var response = await apiService!.getData(endPoint: EndPoints.myAds);
      MyAdsDataModel result = MyAdsDataModel.fromJson(response.data);
      debugPrint(
        'AdvertisementsRepoImpl getMyAdsData: ${result.data?.ads?.length ?? 0} items',
      );
      return right(result);
    } catch (e, s) {
      debugPrint('AdvertisementsRepoImpl getMyAdsData error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, GeneralModel>> deleteAd({required int adId}) async {
    try {
      var response = await apiService!.postData(
        endPoint: EndPoints.deleteAds,
        data: {"ad_id": adId},
      );
      GeneralModel result = GeneralModel.fromJson(response.data);
      debugPrint(
        'AdvertisementsRepoImpl deleteAd: status=${result.status} msg=${result.message}',
      );
      return right(result);
    } catch (e, s) {
      debugPrint('AdvertisementsRepoImpl deleteAd error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, PauseResumeAdModel>> pauseAd({required int adId}) {
    return _changePauseState(endPoint: EndPoints.pauseAd, adId: adId);
  }

  @override
  Future<Either<Failure, PauseResumeAdModel>> resumeAd({required int adId}) {
    return _changePauseState(endPoint: EndPoints.resumeAd, adId: adId);
  }

  Future<Either<Failure, PauseResumeAdModel>> _changePauseState({
    required String endPoint,
    required int adId,
  }) async {
    try {
      var response = await apiService!.postData(
        endPoint: endPoint,
        data: {"ad_id": adId},
      );
      PauseResumeAdModel result = PauseResumeAdModel.fromJson(response.data);
      debugPrint(
        'AdvertisementsRepoImpl $endPoint: status=${result.status} '
        'isPaused=${result.data?.isPaused} msg=${result.message}',
      );
      return right(result);
    } catch (e, s) {
      debugPrint('AdvertisementsRepoImpl $endPoint error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
