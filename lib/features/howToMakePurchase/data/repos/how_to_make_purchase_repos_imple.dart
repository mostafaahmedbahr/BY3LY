import 'package:by3ly/core/extensions/log.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import 'package:by3ly/features/howToMakePurchase/data/models/how_to_make_purchase_model.dart';
import 'package:by3ly/features/howToMakePurchase/data/repos/how_to_make_purchase_repos.dart';

class HowToMakePurchaseRepoImpl implements HowToMakePurchaseRepos {
  final ApiService? apiService;

  HowToMakePurchaseRepoImpl(this.apiService);

  @override
  Future<Either<Failure, HowToMakePurchaseModel>>
  getHowToMakePurchaseData() async {
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.purchaseInstructions,
      );
      HowToMakePurchaseModel result = HowToMakePurchaseModel.fromJson(
        response.data,
      );
      logWarning('HowToMakePurchaseRepoImpl: title=${result.data?.title}');
      return right(result);
    } catch (e, s) {
      logWarning('HowToMakePurchaseRepoImpl error: $e');
      logWarning(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
