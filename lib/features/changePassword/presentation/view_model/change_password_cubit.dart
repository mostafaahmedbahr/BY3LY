import '../../../../main_importants.dart';
import '../../../layout/presentation/view_model/layout_cubit.dart';
import '../../data/models/change_password_model.dart';
import '../../data/repos/change_password_repo.dart';
import 'change_password_states.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStates> {
  ChangePasswordCubit(this.changePasswordRepo)
    : super(ChangePasswordInitState());

  static ChangePasswordCubit get(context) => BlocProvider.of(context);

  ChangePasswordRepo? changePasswordRepo;

  var oldPasswordCon = TextEditingController();
  var newPasswordCon = TextEditingController();
  var confirmNewPasswordCon = TextEditingController();

  ChangePasswordModel? changePasswordModel;
  Future<void> changePassword({
    required String screenName,
  }) async {
    emit(ChangePasswordLoadingState());
    var result = await changePasswordRepo!.changePassword(
      screenName: screenName,
      oldPassword: oldPasswordCon.text,
      newPassword: newPasswordCon.text,
      newPasswordConfirmation: confirmNewPasswordCon.text,
    );
    return result.fold(
      (failure) {
        emit(ChangePasswordErrorState(failure.errMessage));
      },
      (data) async {
        changePasswordModel = data;
        emit(ChangePasswordSuccessState(data));
      },
    );
  }

  bool isOldPasswordVisible = true;
  bool isNewPasswordVisible = true;
  bool isConfirmNewPasswordVisible = true;

  changeOldPasswordVisible() {
    isOldPasswordVisible = !isOldPasswordVisible;
    emit(ChangeOldPasswordVisibleState());
  }

  changeNewPasswordVisible() {
    isNewPasswordVisible = !isNewPasswordVisible;
    emit(ChangeNewPasswordVisibleState());
  }

  changeConfirmNewPasswordVisible() {
    isConfirmNewPasswordVisible = !isConfirmNewPasswordVisible;
    emit(ChangeConfirmNewPasswordVisibleState());
  }

  @override
  Future<void> close() {
    oldPasswordCon.dispose();
    newPasswordCon.dispose();
    confirmNewPasswordCon.dispose();
    return super.close();
  }

  /// Focus Nodes
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmNewPasswordFocusNode = FocusNode();


  void clearUserData() {
    CacheTokenManger.clearUserToken();
    CacheHelper.removeData(key: "email");
    LayoutCubit.pageIndex = 0;
  }
}
