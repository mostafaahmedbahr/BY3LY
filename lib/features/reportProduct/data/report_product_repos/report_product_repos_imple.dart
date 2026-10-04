
import 'package:by3ly/core/errors/failure.dart';
  import 'package:by3ly/features/reportProduct/data/report_product_repos/report_product_repos.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../../../../core/general_models/general_model.dart';
import 'package:by3ly/features/reportProduct/data/report_product_models/add_complaint_model.dart';
import 'package:by3ly/features/reportProduct/data/report_product_models/report_model.dart';
import 'package:by3ly/features/reportProduct/data/report_product_models/report_product_model.dart';


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

  @override
  Future<Either<Failure, ReportModel>> getReportReasons() async {
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.reportReasons,
      );
      ReportModel result = ReportModel.fromJson(response.data);
      debugPrint('ReportProductsReposImpl getReportReasons: ${result.data?.reasons?.length ?? 0} reasons');
      return right(result);
    } catch (e, s) {
      debugPrint('ReportProductsReposImpl getReportReasons error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, GeneralModel>> reportAd({
    required int sellerId,
    required int productId,
    required String reason,
    required String description,
  }) async {
    try {
      var response = await apiService!.postData(
        endPoint: EndPoints.reportAd,
        data: {
          "seller_id": sellerId,
          "product_id": productId,
          "reason": reason,
          "description": description,
        },
      );
      GeneralModel result = GeneralModel.fromJson(response.data);
      debugPrint('ReportProductsReposImpl reportAd: status=${result.status} msg=${result.message}');
      return right(result);
    } catch (e, s) {
      debugPrint('ReportProductsReposImpl reportAd error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }

}
