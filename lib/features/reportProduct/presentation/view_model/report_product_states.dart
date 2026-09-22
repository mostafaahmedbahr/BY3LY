import '../../data/report_product_models/add_complaint_model.dart';
import '../../data/report_product_models/report_product_model.dart';

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

class ResetValuesState extends ReportProductStates{}