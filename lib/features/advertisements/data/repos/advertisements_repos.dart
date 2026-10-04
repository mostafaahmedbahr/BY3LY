import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/general_models/general_model.dart';
import '../models/my_ads_data_model.dart';

abstract class AdvertisementsRepo{

   Future<Either<Failure,MyAdsDataModel>> getMyAdsData();

   Future<Either<Failure,GeneralModel>> deleteAd({required int adId});



}