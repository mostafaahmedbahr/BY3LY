import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/general_models/general_model.dart';
import '../models/wallet_history_model.dart';
import 'wallet_repos.dart';

class WalletRepoImpl implements WalletRepos {
  final ApiService? apiService;

  WalletRepoImpl(this.apiService);

  @override
  Future<Either<Failure, WalletHistoryModel>> getHistory() async {
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.walletHistory,
      );
      WalletHistoryModel result =
          WalletHistoryModel.fromJson(response.data);
      debugPrint(
          'WalletRepo history: ${(result.history ?? []).length} items');
      return right(result);
    } catch (e, s) {
      debugPrint('WalletRepo history error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, GeneralModel>> topUp({
    required String amount,
    required String paymentMethod,
    required String receiptPath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'amount': amount,
        'payment_method': paymentMethod,
      });
      formData.files.add(MapEntry(
        'receipt',
        await MultipartFile.fromFile(receiptPath,
            filename: receiptPath.split('/').last),
      ));
      var response = await apiService!.postData(
        endPoint: EndPoints.walletTopUp,
        data: formData,
      );
      final result = GeneralModel.fromJson(response.data);
      return right(result);
    } catch (e, s) {
      debugPrint('WalletRepo topUp error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
