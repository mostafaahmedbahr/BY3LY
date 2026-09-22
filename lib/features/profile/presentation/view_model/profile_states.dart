import 'package:by3ly/features/profile/data/models/logout_model.dart';
import 'package:by3ly/features/profile/data/models/profile_data_model.dart';

import '../../../deleteAccount/data/models/delete_account_model.dart';

abstract class ProfileStates{}

class ProfileInitState extends ProfileStates{}

class UploadImageInProfileSuccessState extends ProfileStates{}

class ChangeNotificationValueState extends ProfileStates{}

class GetProfileDataLoadingState extends ProfileStates{}
class GetProfileDataSuccessState extends ProfileStates{
  ProfileModel profileModel;
  GetProfileDataSuccessState(this.profileModel);
}
class GetProfileDataErrorState extends ProfileStates{
  final String error;
  GetProfileDataErrorState(this.error);
}


class LogoutLoadingState extends ProfileStates{}
class LogoutSuccessState extends ProfileStates{
  LogoutModel logoutModel;
  LogoutSuccessState(this.logoutModel);
}
class LogoutErrorState extends ProfileStates{
  final String error;
  LogoutErrorState(this.error);
}


class DeleteAccountLoadingState extends ProfileStates{}
class DeleteAccountSuccessState extends ProfileStates{
  DeleteAccountModel deleteAccountModel;
  DeleteAccountSuccessState(this.deleteAccountModel);
}
class DeleteAccountErrorState extends ProfileStates{
  final String error;
  DeleteAccountErrorState(this.error);
}