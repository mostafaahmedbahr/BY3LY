import 'dart:io';

import 'package:by3ly/features/profile/data/models/profile_data_model.dart';
import 'package:by3ly/features/profile/data/repos/profile_repos.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/app_services/local_services/cache_helper.dart';
import '../../../../core/app_services/local_services/cache_token.dart';
import '../../../../core/utils/app_consts/storage_keys.dart';
import '../../../deleteAccount/data/models/delete_account_model.dart';
import '../../data/models/logout_model.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit(this.profileRepos) : super(ProfileInitState());

  static ProfileCubit get(BuildContext context) =>
      BlocProvider.of<ProfileCubit>(context);

  final ProfileRepos profileRepos;

  /// Locally-picked avatar (before the edit form is submitted).
  File? file;

  final ImagePicker _picker = ImagePicker();

  /// Pick an image for the profile photo and preview it locally. The actual
  /// upload happens when the user saves the update-profile form.
  Future<void> uploadOnlyImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked != null) {
        file = File(picked.path);
        emit(UploadImageInProfileSuccessState());
      }
    } catch (e) {
      debugPrint('Picking profile image failed: $e');
    }
  }

  bool switchValue = true;

  void changeNotificationValue(bool newValue) {
    switchValue = newValue;
    emit(ChangeNotificationValueState());
  }

  ProfileModel? profileModel;

  /// Clear cached profile (call on logout / before fresh login).
  void clearProfile() {
    profileModel = null;
    file = null;
    emit(ProfileInitState());
  }

  Future<void> getProfile() async {
    emit(GetProfileDataLoadingState());
    var result = await profileRepos.getProfileData();
    return result.fold(
      (failure) {
        emit(GetProfileDataErrorState(failure.errMessage));
      },
      (data) {
        profileModel = data;
        emit(GetProfileDataSuccessState(data));
      },
    );
  }

  LogoutModel? logoutModel;

  Future<void> logout() async {
    emit(LogoutLoadingState());
    var result = await profileRepos.logout();
    return result.fold(
      (failure) {
        emit(LogoutErrorState(failure.errMessage));
      },
      (data) async {
        logoutModel = data;
        // Clear everything BEFORE emitting success so no stale data remains.
        await _clearSession();
        emit(LogoutSuccessState(data));
      },
    );
  }

  DeleteAccountModel? deleteAccountModel;

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoadingState());
    var result = await profileRepos.deleteAccount();
    return result.fold(
      (failure) {
        emit(DeleteAccountErrorState(failure.errMessage));
      },
      (data) async {
        deleteAccountModel = data;
        await _clearSession();
        emit(DeleteAccountSuccessState(data));
      },
    );
  }

  Future<void> _clearSession() async {
    profileModel = null;
    file = null;
    CacheTokenManger.userToken = null;
    await CacheTokenManger.clearUserToken();
    await CacheHelper.removeData(key: StorageKeys.userToken);
    await CacheHelper.removeData(key: StorageKeys.isGuest);
    await CacheHelper.removeData(key: 'email');
  }
}
