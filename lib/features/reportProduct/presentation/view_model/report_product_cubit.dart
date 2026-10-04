import 'package:by3ly/features/reportProduct/data/report_product_repos/report_product_repos.dart';
import 'package:by3ly/features/reportProduct/presentation/view_model/report_product_states.dart';
import 'package:by3ly/main_importants.dart';

import 'package:by3ly/features/reportProduct/data/report_product_models/add_complaint_model.dart';
import 'package:by3ly/features/reportProduct/data/report_product_models/report_model.dart';
import 'package:by3ly/features/reportProduct/data/report_product_models/report_product_model.dart';

class ReportProductCubit extends Cubit<ReportProductStates> {
  ReportProductCubit(this.reportProductsRepos)
      : super(ReportProductInitState());

  static ReportProductCubit get(context) => BlocProvider.of(context);

  int reasonIndex = 0;
  var   messageCon = TextEditingController();

  resetValues()
  {
    reasonIndex = 0;
    messageCon.clear();
    emit(ResetValuesState());
  }
  chooseReason(index) {
    reasonIndex = index;
    emit(ReportProductChooseReasonState());
  }

  ReportProductsRepos? reportProductsRepos;
  ReportProductComplaintsTypesModel? reportProductComplaintsTypesModel;

  List<Complaints> allComplaintsTypesList = [];

  Future<void> getAllComplaintsTypesData() async {
    emit(GetComplaintsTypesLoading());
    var result = await reportProductsRepos!.getComplaintsTypes();
    return result.fold((failure) {
      emit(GetComplaintsTypesError(failure.errMessage));
    }, (data) {
      reportProductComplaintsTypesModel = data;
      allComplaintsTypesList = allComplaintsTypesList +
          reportProductComplaintsTypesModel!.data!.complaints!;
      emit(GetComplaintsTypesSuccess(data));
    });
  }

  AddComplaintModel? addComplaintModel;

  Future<void> addComplaint({
    int? sellerId,
    int? productId,
    required String message,
    required int complaintId,
  }) async {
    emit(AddComplaintLoading());
    var result = await reportProductsRepos!.addComplaint(
      sellerId: sellerId,
      productId: productId,
      message: message,
      complaintId: complaintId,
    );
    return result.fold((failure) {
      emit(AddComplaintError(failure.errMessage));
    }, (data) {
      addComplaintModel = data;
      emit(AddComplaintSuccess(data));
    });
  }

  // ---- Report-ad flow (reasons + reportAd) ----

  ReportModel? reportModel;
  List<Reasons> get reportReasons => reportModel?.data?.reasons ?? [];

  String? selectedReasonKey;
  var reportDescCon = TextEditingController();

  Future<void> getReportReasons() async {
    if (reportReasons.isNotEmpty) return;
    emit(GetReportReasonsLoading());
    var result = await reportProductsRepos!.getReportReasons();
    return result.fold((failure) {
      debugPrint('ReportProductCubit getReportReasons failed: ${failure.errMessage}');
      emit(GetReportReasonsError(failure.errMessage));
    }, (data) {
      reportModel = data;
      emit(GetReportReasonsSuccess());
    });
  }

  void selectReportReason(String key) {
    selectedReasonKey = key;
    emit(ReportReasonSelected(key));
  }

  void resetReportAd() {
    selectedReasonKey = null;
    reportDescCon.clear();
    emit(ResetValuesState());
  }

  Future<void> submitReportAd({
    required int sellerId,
    required int productId,
  }) async {
    final reason = selectedReasonKey;
    if (reason == null || reason.isEmpty) {
      emit(ReportAdError('selectReason'));
      return;
    }
    emit(ReportAdLoading());
    var result = await reportProductsRepos!.reportAd(
      sellerId: sellerId,
      productId: productId,
      reason: reason,
      description: reportDescCon.text.trim(),
    );
    return result.fold((failure) {
      debugPrint('ReportProductCubit submitReportAd failed: ${failure.errMessage}');
      emit(ReportAdError(failure.errMessage));
    }, (data) {
      if (data.status == true) {
        emit(ReportAdSuccess(data.message));
        resetReportAd();
      } else {
        emit(ReportAdError(data.message ?? 'Something went wrong'));
      }
    });
  }
}
