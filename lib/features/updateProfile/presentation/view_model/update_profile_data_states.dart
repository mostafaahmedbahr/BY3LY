import 'package:by3ly/features/updateProfile/data/models/update_profile_data_model.dart';

abstract class UpdateProfileDataStates{}

class UpdateProfileDataInitState extends UpdateProfileDataStates{}

class UpdateProfileDataLoadingState extends UpdateProfileDataStates{}
class UpdateProfileDataSuccessState extends UpdateProfileDataStates{
  final UpdateProfileDataModel updateProfileDataModel;
  UpdateProfileDataSuccessState(this.updateProfileDataModel);
}
class UpdateProfileDataErrorState extends UpdateProfileDataStates{
  final String error;
  UpdateProfileDataErrorState(this.error);

}

class UploadImageSuccessState extends UpdateProfileDataStates{}
class UploadImageErrorState extends UpdateProfileDataStates{}
class ClearImageSuccessState extends UpdateProfileDataStates{}