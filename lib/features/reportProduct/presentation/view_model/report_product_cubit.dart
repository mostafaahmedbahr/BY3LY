import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:by3ly/features/reportProduct/data/report_product_models/add_complaint_model.dart';
import 'package:by3ly/features/reportProduct/data/report_product_models/report_model.dart';
import 'package:by3ly/features/reportProduct/data/report_product_models/report_product_model.dart';
import 'package:by3ly/features/reportProduct/data/report_product_repos/report_product_repos.dart';
import 'package:by3ly/features/reportProduct/presentation/view_model/report_product_states.dart';

class ReportProductCubit extends Cubit<ReportProductStates> {
  ReportProductCubit(this.reportProductsRepos)
      : super(ReportProductInitState());

  static ReportProductCubit get(BuildContext context) =>
      BlocProvider.of<ReportProductCubit>(context);

  final ReportProductsRepos reportProductsRepos;

  /// Currently selected complaint reason — null until the user picks one.
  int? reasonIndex;
  final TextEditingController messageCon = TextEditingController();

  void resetValues() {
    reasonIndex = null;
    messageCon.clear();
    emit(ResetValuesState());
  }

  void chooseReason(int? index) {
    reasonIndex = index;
    emit(ReportProductChooseReasonState());
  }

  ReportProductComplaintsTypesModel? reportProductComplaintsTypesModel;

  List<Complaints> allComplaintsTypesList = [];

  Future<void> getAllComplaintsTypesData() async {
    emit(GetComplaintsTypesLoading());
    var result = await reportProductsRepos.getComplaintsTypes();
    return result.fold(
      (failure) {
        emit(GetComplaintsTypesError(failure.errMessage));
      },
      (data) {
        reportProductComplaintsTypesModel = data;
        // Replace, never accumulate (refetch must not duplicate rows).
        allComplaintsTypesList = data.data?.complaints ?? [];
        emit(GetComplaintsTypesSuccess(data));
      },
    );
  }

  AddComplaintModel? addComplaintModel;

  Future<void> addComplaint({
    int? sellerId,
    int? productId,
    required String message,
    required int complaintId,
  }) async {
    emit(AddComplaintLoading());
    var result = await reportProductsRepos.addComplaint(
      sellerId: sellerId,
      productId: productId,
      message: message,
      complaintId: complaintId,
    );
    return result.fold(
      (failure) {
        emit(AddComplaintError(failure.errMessage));
      },
      (data) {
        addComplaintModel = data;
        emit(AddComplaintSuccess(data));
      },
    );
  }

  // ---- Report-ad flow (reasons + reportAd) ----

  ReportModel? reportModel;
  List<Reasons> get reportReasons => reportModel?.data?.reasons ?? [];

  String? selectedReasonKey;
  final TextEditingController reportDescCon = TextEditingController();

  Future<void> getReportReasons() async {
    if (reportReasons.isNotEmpty) return;
    emit(GetReportReasonsLoading());
    var result = await reportProductsRepos.getReportReasons();
    return result.fold(
      (failure) {
        debugPrint(
            'ReportProductCubit getReportReasons failed: ${failure.errMessage}');
        emit(GetReportReasonsError(failure.errMessage));
      },
      (data) {
        reportModel = data;
        emit(GetReportReasonsSuccess());
      },
    );
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
    var result = await reportProductsRepos.reportAd(
      sellerId: sellerId,
      productId: productId,
      reason: reason,
      description: reportDescCon.text.trim(),
    );
    return result.fold(
      (failure) {
        debugPrint(
            'ReportProductCubit submitReportAd failed: ${failure.errMessage}');
        emit(ReportAdError(failure.errMessage));
      },
      (data) {
        if (data.status == true) {
          emit(ReportAdSuccess(data.message));
          resetReportAd();
        } else {
          emit(ReportAdError(data.message ?? 'Something went wrong'));
        }
      },
    );
  }
}
