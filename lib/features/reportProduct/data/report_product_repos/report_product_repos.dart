 import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../report_product_models/add_complaint_model.dart';
import '../report_product_models/report_product_model.dart';

abstract class ReportProductsRepos{

  Future<Either<Failure,ReportProductComplaintsTypesModel>> getComplaintsTypes();
  Future<Either<Failure,AddComplaintModel>> addComplaint({
    int? sellerId, int? productId,
    required String message, required int complaintId
  });



}