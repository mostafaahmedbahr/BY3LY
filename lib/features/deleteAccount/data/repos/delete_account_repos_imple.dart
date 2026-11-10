import 'package:by3ly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/delete_account_model.dart';
import 'delete_account_repos.dart';

class DeleteAccountReposImple implements DeleteAccountRepos {
  final ApiService? apiService;

  DeleteAccountReposImple(this.apiService);

  @override
  Future<Either<Failure, DeleteAccountModel>> deleteAccount() async {
    try {
      final response = await apiService!.postData(
        endPoint: EndPoints.deleteAccount,
      );
      final result = DeleteAccountModel.fromJson(response.data);
      debugPrint('DeleteAccountReposImple deleteAccount: status=${result.status}');
      return right(result);
    } catch (e) {
      debugPrint('DeleteAccountReposImple deleteAccount error: $e');
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
