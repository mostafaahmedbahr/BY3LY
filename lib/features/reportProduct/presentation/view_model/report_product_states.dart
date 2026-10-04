import 'package:by3ly/features/reportProduct/data/report_product_models/add_complaint_model.dart';
import 'package:by3ly/features/reportProduct/data/report_product_models/report_product_model.dart';

abstract class ReportProductStates{}

class ReportProductInitState extends ReportProductStates{}

class ReportProductChooseReasonState extends ReportProductStates{}

class GetComplaintsTypesLoading extends ReportProductStates {}

class GetComplaintsTypesSuccess extends ReportProductStates {
  final ReportProductComplaintsTypesModel reportProductComplaintsTypesModel;
  GetComplaintsTypesSuccess(this.reportProductComplaintsTypesModel);
}

class GetComplaintsTypesError extends ReportProductStates {
  final String message;
  GetComplaintsTypesError(this.message);
}


class AddComplaintLoading extends ReportProductStates {}

class AddComplaintSuccess extends ReportProductStates {
  final AddComplaintModel addComplaintModel;
  AddComplaintSuccess(this.addComplaintModel);
}

class AddComplaintError extends ReportProductStates {
  final String message;
  AddComplaintError(this.message);
}

class ResetValuesState extends ReportProductStates{
  @override
  String toString() => 'ResetValuesState';
}

class GetReportReasonsLoading extends ReportProductStates {
  @override
  String toString() => 'GetReportReasonsLoading';
}

class GetReportReasonsSuccess extends ReportProductStates {
  @override
  String toString() => 'GetReportReasonsSuccess';
}

class GetReportReasonsError extends ReportProductStates {
  final String message;
  GetReportReasonsError(this.message);

  @override
  String toString() => 'GetReportReasonsError(message: $message)';
}

class ReportReasonSelected extends ReportProductStates {
  final String reasonKey;
  ReportReasonSelected(this.reasonKey);

  @override
  String toString() => 'ReportReasonSelected(reasonKey: $reasonKey)';
}

class ReportAdLoading extends ReportProductStates {
  @override
  String toString() => 'ReportAdLoading';
}

class ReportAdSuccess extends ReportProductStates {
  final String? message;
  ReportAdSuccess(this.message);

  @override
  String toString() => 'ReportAdSuccess(message: $message)';
}

class ReportAdError extends ReportProductStates {
  final String message;
  ReportAdError(this.message);

  @override
  String toString() => 'ReportAdError(message: $message)';
}