import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/register/data/repos/register_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/register_model.dart';


class RegisterRepoImpl implements RegisterRepo {
  final ApiService? apiService;

  RegisterRepoImpl(this.apiService);

  @override
  Future<Either<Failure, RegisterModel>> register({required dynamic data}) async{
    try {
      var response = await apiService!.postData(
        endPoint: EndPoints.register,
        data: data,
        isMultipart: true,
      );
      RegisterModel result = RegisterModel.fromJson(response.data);
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
