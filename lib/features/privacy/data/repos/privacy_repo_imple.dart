import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../../../../core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../models/settings_model.dart';
import 'privacy_repo.dart';

class PrivacyRepoImpl implements PrivacyRepo {
  final ApiService? apiService;

  PrivacyRepoImpl(this.apiService);

  @override
  Future<Either<Failure, SettingsModel>> getSettings() async {
    try {
      final response = await apiService!.getData(endPoint: EndPoints.settings);
      final result = SettingsModel.fromJson(response.data);
      debugPrint(
        'PrivacyRepoImpl getSettings: status=${result.status} '
        'method=${result.data?.settings?.contactMethod}',
      );
      return right(result);
    } catch (e, s) {
      debugPrint('PrivacyRepoImpl getSettings error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SettingsModel>> updateSettings({
    required String contactMethod,
    required String contactPhone,
    required bool notifyNewProducts,
    String? storeName,
    String? storeAddress,
  }) async {
    try {
      final data = <String, dynamic>{
        "contact_method": contactMethod,
        "contact_phone": contactPhone,
        "notify_new_products": notifyNewProducts,
      };
      // Only send the store fields when known; the backend keeps the current
      // values for omitted keys.
      if (storeName != null) data["store_name"] = storeName;
      if (storeAddress != null) data["store_address"] = storeAddress;

      final response = await apiService!.patchData(
        endPoint: EndPoints.settings,
        data: data,
      );
      final result = SettingsModel.fromJson(response.data);
      debugPrint(
        'PrivacyRepoImpl updateSettings: status=${result.status} '
        'msg=${result.message}',
      );
      return right(result);
    } catch (e, s) {
      debugPrint('PrivacyRepoImpl updateSettings error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
