import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../../../../core/errors/failure.dart';
import '../models/packages_model.dart';
import '../models/payment_methods_model.dart';
import '../models/subscribe_package_model.dart';
import 'packages_repos.dart';

class PackagesRepoImpl implements PackagesRepos {
  final ApiService? apiService;

  PackagesRepoImpl(this.apiService);

  @override
  Future<Either<Failure, PackagesModel>> getPackages() async {
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.subscriptionPackages,
      );
      PackagesModel result = PackagesModel.fromJson(response.data);
      debugPrint(
          'PackagesRepo get: ${(result.data?.packages ?? []).length} packages');
      return right(result);
    } catch (e, s) {
      debugPrint('PackagesRepo get error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, PaymentMethodsModel>> getPaymentMethods() async {
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.paymentMethods,
      );
      PaymentMethodsModel result =
          PaymentMethodsModel.fromJson(response.data);
      debugPrint(
          'PackagesRepo methods: ${(result.data?.methods ?? []).length}');
      return right(result);
    } catch (e, s) {
      debugPrint('PackagesRepo methods error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, SubscribePackageModel>> checkout({
    required int packageId,
    required String paymentMethod,
    String? receiptPath,
  }) async {
    try {
      dynamic payload;
      if (receiptPath != null && receiptPath.isNotEmpty) {
        final formData = FormData.fromMap({
          'package_id': packageId,
          'payment_method': paymentMethod,
        });
        formData.files.add(MapEntry(
          'receipt',
          await MultipartFile.fromFile(receiptPath,
              filename: receiptPath.split('/').last),
        ));
        payload = formData;
      } else {
        payload = {
          "package_id": packageId,
          "payment_method": paymentMethod,
        };
      }
      var response = await apiService!.postData(
        endPoint: EndPoints.subscriptionsCheckout,
        data: payload,
      );
      final result = SubscribePackageModel.fromJson(response.data);
      return right(result);
    } catch (e, s) {
      debugPrint('PackagesRepo checkout error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
