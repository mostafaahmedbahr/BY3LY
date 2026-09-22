import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/my_ads_data_model.dart';

abstract class AdvertisementsRepo{

   Future<Either<Failure,MyAdsDataModel>> getMyAdsData({required int type});



}