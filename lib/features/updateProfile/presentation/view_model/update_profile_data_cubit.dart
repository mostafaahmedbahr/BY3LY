import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:by3ly/features/profile/data/models/profile_data_model.dart';
import 'package:by3ly/features/updateProfile/data/models/update_profile_data_model.dart';
import 'package:by3ly/features/updateProfile/data/repos/update_profile_data_repo.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_states.dart';

class UpdateProfileDataCubit extends Cubit<UpdateProfileDataStates> {
  UpdateProfileDataCubit(this.updateProfileDataRepos)
      : super(UpdateProfileDataInitState());

  static UpdateProfileDataCubit get(BuildContext context) =>
      BlocProvider.of<UpdateProfileDataCubit>(context);

  final UpdateProfileDataRepos updateProfileDataRepos;

  UpdateProfileDataModel? updateProfileDataModel;

  final ImagePicker picker = ImagePicker();
  File? profileImage;

  final TextEditingController nameCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController phoneCon = TextEditingController();

  Future<void> updateProfileData({
    required File? image,
    required String? fullName,
    required String? email,
    required String? phoneNumber,
  }) async {
    emit(UpdateProfileDataLoadingState());
    Map<String, dynamic> formMap = {
      if (image != null)
        "image": await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last),
      if (fullName != null && fullName.isNotEmpty) "name": fullName,
      if (email != null && email.isNotEmpty) "email": email,
      if (phoneNumber != null && phoneNumber.isNotEmpty) "phone": phoneNumber,
    };

    if (formMap.isEmpty) {
      emit(UpdateProfileDataErrorState('nothingToSend'));
      return;
    }

    FormData formData = FormData.fromMap(formMap);
    var result = await updateProfileDataRepos.updateProfileData(data: formData);
    return result.fold(
      (failure) {
        emit(UpdateProfileDataErrorState(failure.errMessage));
      },
      (data) async {
        updateProfileDataModel = data;
        emit(UpdateProfileDataSuccessState(data));
      },
    );
  }

  Future<void> uploadProfilePicture() async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        emit(UploadImageSuccessState());
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      emit(UploadImageErrorState());
    }
  }

  void clearProfileImage() {
    profileImage = null;
    emit(ClearImageSuccessState());
  }

  void initControllers(ProfileModel profile) {
    final user = profile.data?.user;
    nameCon.text = user?.name ?? '';
    emailCon.text = user?.email ?? '';
    phoneCon.text = user?.phone ?? '';
  }

  @override
  Future<void> close() {
    nameCon.dispose();
    emailCon.dispose();
    phoneCon.dispose();
    return super.close();
  }
}
