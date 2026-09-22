import 'package:by3ly/features/reportProduct/data/report_product_repos/report_product_repos.dart';
import 'package:by3ly/features/reportProduct/presentation/view_model/report_product_states.dart';
import 'package:by3ly/main_importants.dart';

import '../../data/report_product_models/add_complaint_model.dart';
import '../../data/report_product_models/report_product_model.dart';

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
}
