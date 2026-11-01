import 'package:by3ly/core/general_models/general_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../models/add_product_to_compare_model.dart';
import '../models/pause_resume_ad_model.dart' show PauseAdResumeAdModel;
import '../models/product_details_model.dart';

abstract class ProductDetailsRepo {
  Future<Either<Failure, ProductDetailsModel>> getProductDetailsData({
    required int productId,
    required String type,
  });

  Future<Either<Failure, AddProductToCompareModel>> addProductToCompare({
    required int productId,
  });

  Future<Either<Failure, GeneralModel>> rateProduct({
    required int productId,
    required int rate,
    required String commenet,
  });

  /// Temporarily hides the seller's own ad.
  Future<Either<Failure, PauseAdResumeAdModel>> pauseAd({required int adId});

  /// Shows the seller's own ad again after it was paused.
  Future<Either<Failure, PauseAdResumeAdModel>> resumeAd({required int adId});
}
