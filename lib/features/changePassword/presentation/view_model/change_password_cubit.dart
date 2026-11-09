import '../../../../main_importants.dart';
import '../../../layout/presentation/view_model/layout_cubit.dart';
import '../../data/models/change_password_model.dart';
import '../../data/repos/change_password_repo.dart';
import 'change_password_states.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStates> {
  ChangePasswordCubit(this.changePasswordRepo)
      : super(ChangePasswordInitState());

  static ChangePasswordCubit get(BuildContext context) =>
      BlocProvider.of<ChangePasswordCubit>(context);

  final ChangePasswordRepo changePasswordRepo;

  final oldPasswordCon = TextEditingController();
  final newPasswordCon = TextEditingController();
  final confirmNewPasswordCon = TextEditingController();

  ChangePasswordModel? changePasswordModel;

  bool isOldPasswordVisible = true;
  bool isNewPasswordVisible = true;
  bool isConfirmNewPasswordVisible = true;

  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmNewPasswordFocusNode = FocusNode();

  Future<void> changePassword() async {
    emit(ChangePasswordLoadingState());
    final result = await changePasswordRepo.changePassword(
      oldPassword: oldPasswordCon.text,
      newPassword: newPasswordCon.text,
      newPasswordConfirmation: confirmNewPasswordCon.text,
    );
    return result.fold(
      (failure) {
        emit(ChangePasswordErrorState(failure.errMessage));
      },
      (data) {
        changePasswordModel = data;
        emit(ChangePasswordSuccessState(data));
      },
    );
  }

  void changeOldPasswordVisible() {
    isOldPasswordVisible = !isOldPasswordVisible;
    emit(ChangeOldPasswordVisibleState());
  }

  void changeNewPasswordVisible() {
    isNewPasswordVisible = !isNewPasswordVisible;
    emit(ChangeNewPasswordVisibleState());
  }

  void changeConfirmNewPasswordVisible() {
    isConfirmNewPasswordVisible = !isConfirmNewPasswordVisible;
    emit(ChangeConfirmNewPasswordVisibleState());
  }

  @override
  Future<void> close() {
    oldPasswordCon.dispose();
    newPasswordCon.dispose();
    confirmNewPasswordCon.dispose();
    newPasswordFocusNode.dispose();
    confirmNewPasswordFocusNode.dispose();
    return super.close();
  }

  /// Wipes local credentials and sends the user back to the login flow.
  void clearUserData() {
    CacheTokenManger.clearUserToken();
    CacheHelper.removeData(key: "email");
    LayoutCubit.pageIndex = 0;
  }
}
