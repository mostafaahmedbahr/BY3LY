import '../../data/models/register_model.dart';

abstract class RegisterStates{}

class RegisterInitState extends RegisterStates{}

class ChangeSuffixIconState  extends RegisterStates{}
class ChangeSuffixIconState2  extends RegisterStates{}

class UploadImageSuccessState  extends RegisterStates{}
class UploadImageErrorState  extends RegisterStates{}
class ClearImageSuccessState  extends RegisterStates{}

class SignUpLoading  extends RegisterStates{}
class SignUpSuccess  extends RegisterStates{
  final RegisterModel registerModel;
  SignUpSuccess(this.registerModel);
}
class SignUpError  extends RegisterStates{
  final String message;
  SignUpError(this.message);
}
class ClearDataSuccess extends RegisterStates{}