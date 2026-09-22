
import 'package:by3ly/core/errors/failure.dart';
  import 'package:by3ly/features/reportProduct/data/report_product_repos/report_product_repos.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../report_product_models/add_complaint_model.dart';
import '../report_product_models/report_product_model.dart';


class ReportProductsReposImpl implements ReportProductsRepos {
  final ApiService? apiService;

  ReportProductsReposImpl(this.apiService);


  @override
  Future<Either<Failure, ReportProductComplaintsTypesModel>> getComplaintsTypes() async{
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.complaintsTypes,
      );
      ReportProductComplaintsTypesModel result = ReportProductComplaintsTypesModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, AddComplaintModel>> addComplaint(
      {int? sellerId, int? productId ,
        required String message, required int complaintId}) async{
    try {
      var response = await apiService!.postData(
        
        endPoint: EndPoints.addComplaint,
        data: {
          "complaint_id" : complaintId,
          "seller_id" : sellerId,
          "product_id" : productId,
          "message" : message,
        },
      );
      AddComplaintModel result = AddComplaintModel.fromJson(response.data);
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
