import 'package:by3ly/core/general_models/general_model.dart';
import 'package:by3ly/features/addAdvertisements/data/models/ad_publishing_settings_model.dart';
import 'package:by3ly/features/addAdvertisements/data/models/current_subscription_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

abstract class AddAdvertisementsRepos {
  /// Create a new ad (unified create-ad endpoint).
  ///
  /// [paymentMethod] is omitted when the user publishes under an active
  /// subscription package; otherwise 'wallet' or a transfer method code
  /// (+ [receiptPath] and [transferReference] for transfers).
  Future<Either<Failure, GeneralModel>> addNewAd({
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
    String? paymentMethod,
    String? receiptPath,
    String? transferReference,
  });

  /// Fixed publishing fee + transfer accounts
  /// (GET /api/ad-publishing-settings).
  Future<Either<Failure, AdPublishingSettingsModel>>
      getAdPublishingSettings();

  /// Active subscription (GET /api/subscriptions/current) — decides
  /// whether publishing is covered by the package or needs payment.
  Future<Either<Failure, CurrentSubscriptionModel>>
      getCurrentSubscription();

  /// Edit an existing ad (same fields + ad_id, new image files only).
  Future<Either<Failure, GeneralModel>> editAd({
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
