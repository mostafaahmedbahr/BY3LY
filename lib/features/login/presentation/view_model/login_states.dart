import 'package:by3ly/features/login/data/models/login_model.dart';

abstract class LoginStates {}

class LoginInitState extends LoginStates {
  @override
  String toString() => 'LoginInitState';
}

class LoginLoadingState extends LoginStates {
  @override
  String toString() => 'LoginLoadingState';
}

class LoginSuccessState extends LoginStates {
  LoginSuccessState(this.loginModel);
  final LoginModel loginModel;

  @override
  String toString() => 'LoginSuccessState';
}

/// Account exists but hasn't been activated yet — the listener routes
/// to the OTP screen. `code` is kept nullable for backwards compatibility
/// (older servers embedded the code in the payload).
class LoginSuccessWithNoActiveState extends LoginStates {
  LoginSuccessWithNoActiveState({this.code});
  final int? code;

  @override
  String toString() => 'LoginSuccessWithNoActiveState(code: $code)';
}

class LoginErrorState extends LoginStates {
  LoginErrorState(this.error);
  final String error;

  @override
  String toString() => 'LoginErrorState(error: $error)';
}

class ChangePasswordVisibleState extends LoginStates {
  @override
  String toString() => 'ChangePasswordVisibleState';
}
