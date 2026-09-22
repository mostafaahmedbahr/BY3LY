import 'package:by3ly/core/errors/failure.dart';
  import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
 import '../models/how_to_make_purchase_model.dart';
import 'how_to_make_purchase_repos.dart';



class HowToMakePurchaseRepoImpl implements HowToMakePurchaseRepos {
  final ApiService? apiService;

  HowToMakePurchaseRepoImpl(this.apiService);


  @override
  Future<Either<Failure, HowToMakePurchaseModel>> getHowToMakePurchaseData() async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.makePurchase,
      );
      HowToMakePurchaseModel result = HowToMakePurchaseModel.fromJson(response.data);
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
