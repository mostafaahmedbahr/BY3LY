import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/allCategories/data/models/all_categoies_model.dart';
import 'package:by3ly/features/allCategories/data/repositories/all_categories_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/delete_account_model.dart';
import 'delete_account_repos.dart';


class DeleteAccountReposImple implements DeleteAccountRepos {
  final ApiService? apiService;

  DeleteAccountReposImple(this.apiService);


  @override
  Future<Either<Failure, DeleteAccountModel>> deleteAccount() async{
    try {
      var response = await apiService!.postData(
        endPoint: EndPoints.deleteAccount,
        
      );
      DeleteAccountModel result = DeleteAccountModel.fromJson(response.data);
      print(response.data);
      print("DeleteAccountReposImple deleteAccount");
      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
