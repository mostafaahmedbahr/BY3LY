import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
import 'package:by3ly/features/addAdvertisements/data/models/ad_publishing_settings_model.dart';
import 'package:by3ly/features/addAdvertisements/data/models/current_subscription_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import 'add_advertisements_repos.dart';

class AddAdvertisementsRepoImpl implements AddAdvertisementsRepos {
  final ApiService? apiService;

  AddAdvertisementsRepoImpl(this.apiService);

  Future<List<MapEntry<String, MultipartFile>>> _imageEntries(
    List<dynamic> images,
  ) async {
    final entries = <MapEntry<String, MultipartFile>>[];
    for (final image in images) {
      entries.add(
        MapEntry(
          'images[]',
          await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        ),
      );
    }
    return entries;
  }

  @override
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
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'description': description,
        'price': price,
        if (discount != null && discount.trim().isNotEmpty)
          'discount': discount,
        'is_negotiable': isNegotiable,
        'is_urgent': isUrgent,
        'listing_type': 'sale',
        'category_id': categoryId,
        'sub_category_id': subCategoryId,
        'shipping_type': shippingType,
        'condition': condition,
        'city_id': cityId,
        'center_id': centerId,
        // Omitted when publishing under an active subscription package.
        if (paymentMethod != null && paymentMethod.trim().isNotEmpty)
          'payment_method': paymentMethod,
        // Transfer reference number (optional, transfer methods only).
        if (transferReference != null &&
            transferReference.trim().isNotEmpty)
          'transfer_reference': transferReference.trim(),
      });
      formData.files.addAll(await _imageEntries(images));
      // Transfer receipt (required when payment_method != wallet).
      if (receiptPath != null && receiptPath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'receipt',
            await MultipartFile.fromFile(
              receiptPath,
              filename: receiptPath.split('/').last,
            ),
          ),
        );
      }
      var response = await apiService!.postData(
        endPoint: EndPoints.addNewAds,
        data: formData,
      );
      GeneralModel result = GeneralModel.fromJson(response.data);
      debugPrint('AddAdvertisementsRepoImpl addNewAd: status=${result.status} msg=${result.message}');
      return right(result);
    } catch (e, s) {
      debugPrint('AddAdvertisementsRepoImpl addNewAd error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, AdPublishingSettingsModel>>
      getAdPublishingSettings() async {
    try {
      final response = await apiService!.getData(
        endPoint: EndPoints.adPublishingSettings,
      );
      return right(AdPublishingSettingsModel.fromJson(response.data));
    } catch (e, s) {
      debugPrint('AddAdvertisementsRepoImpl getAdPublishingSettings error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, CurrentSubscriptionModel>>
      getCurrentSubscription() async {
    try {
      final response = await apiService!.getData(
        endPoint: EndPoints.subscriptionsCurrent,
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        // No subscription payload → not covered by a package.
        return right(CurrentSubscriptionModel());
      }
      return right(CurrentSubscriptionModel.fromJson(data));
    } catch (e, s) {
      debugPrint('AddAdvertisementsRepoImpl getCurrentSubscription error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
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
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'ad_id': adId,
        'name': name,
        'description': description,
        'price': price,
        if (discount != null && discount.trim().isNotEmpty)
          'discount': discount,
        'is_negotiable': isNegotiable,
        'is_urgent': isUrgent,
        'listing_type': 'sale',
        'category_id': categoryId,
        'sub_category_id': subCategoryId,
        'shipping_type': shippingType,
        'condition': condition,
        'city_id': cityId,
        'center_id': centerId,
      });
      formData.files.addAll(await _imageEntries(images));
      var response = await apiService!.postData(
        endPoint: EndPoints.editAd,
        data: formData,
      );
      GeneralModel result = GeneralModel.fromJson(response.data);
      debugPrint('AddAdvertisementsRepoImpl editAd: status=${result.status} msg=${result.message}');
      return right(result);
    } catch (e, s) {
      debugPrint('AddAdvertisementsRepoImpl editAd error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
