abstract class ChangePasswordStates{}

class ChangePasswordInitState extends ChangePasswordStates{}

class ChangePasswordLoadingState extends ChangePasswordStates{}
class ChangePasswordSuccessState extends ChangePasswordStates{
  dynamic changePasswordModel;
  ChangePasswordSuccessState(this.changePasswordModel);
}
class ChangePasswordErrorState extends ChangePasswordStates{
  final String error;
  ChangePasswordErrorState(this.error);
}

class ChangeOldPasswordVisibleState extends ChangePasswordStates{}
class ChangeNewPasswordVisibleState extends ChangePasswordStates{}
class ChangeConfirmNewPasswordVisibleState extends ChangePasswordStates{}
