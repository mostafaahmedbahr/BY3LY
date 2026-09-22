import 'dart:io';
import 'package:by3ly/features/profile/data/models/profile_data_model.dart';
import 'package:by3ly/features/profile/data/repos/profile_repos.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_services/local_services/cache_token.dart';
import '../../../deleteAccount/data/models/delete_account_model.dart';
import '../../data/models/logout_model.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit(this.profileRepos) : super(ProfileInitState());

  static ProfileCubit get(context) => BlocProvider.of(context);



  File? file;
  Future uploadOnlyImage() async {
    // FilePickerResult? result = await FilePicker.pickFiles(
    //   allowedExtensions: ["jpg", "png", "jpeg"],
    //   type: FileType.custom,
    // );
    // file = File(result?.files.single.path ?? "");
    // debugPrint("---------- upload is done ------------");
    // if(file!.path !=""){
    //   emit(UploadImageInProfileSuccessState());
    // }

  }


  bool switchValue = true;

  changeNotificationValue(newValue)
  {
    switchValue = newValue;
    emit(ChangeNotificationValueState());
  }



  ProfileRepos? profileRepos;
  ProfileModel? profileModel;

  Future<void> getProfile() async {
    emit(GetProfileDataLoadingState());
    var result = await profileRepos!.getProfileData();
    return result.fold((failure) {
      emit(GetProfileDataErrorState(failure.errMessage));
    }, (data) {
      profileModel = data;
       emit(GetProfileDataSuccessState(data));
    });
  }


  LogoutModel? logoutModel;

  Future<void> logout() async {
    emit(LogoutLoadingState());
    var result = await profileRepos!.logout();
    return result.fold((failure) {
      emit(LogoutErrorState(failure.errMessage));
    }, (data) async {
      logoutModel = data;
      emit(LogoutSuccessState(data));
      await CacheTokenManger.clearUserToken();
    });
  }



  DeleteAccountModel? deleteAccountModel;

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoadingState());
    var result = await profileRepos!.deleteAccount();
    return result.fold((failure) {
      emit(DeleteAccountErrorState(failure.errMessage));
    }, (data) async {
      deleteAccountModel = data;
      emit(DeleteAccountSuccessState(data));
      await CacheTokenManger.clearUserToken();
    });
  }


}