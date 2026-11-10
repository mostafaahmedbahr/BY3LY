import 'dart:io';
import 'package:by3ly/features/register/presentation/view_model/register_states.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_services/local_services/cache_helper.dart';
import '../../data/models/register_model.dart';
import '../../data/repos/register_repo.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit(this.registerRepo) : super(RegisterInitState());

  final RegisterRepo registerRepo;

  static RegisterCubit get(BuildContext context) =>
      BlocProvider.of<RegisterCubit>(context);

  bool isVisible = true;

  void changeSuffixIcon() {
    isVisible = !isVisible;
    emit(ChangeSuffixIconState());
  }

  bool isVisible2 = true;

  void changeSuffixIcon2() {
    isVisible2 = !isVisible2;
    emit(ChangeSuffixIconState2());
  }

  final TextEditingController passCon = TextEditingController();
  final TextEditingController confirmPassCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController mobileCon = TextEditingController();
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController ageCon = TextEditingController();

  final ImagePicker picker = ImagePicker();
  File? profileImage;

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

  RegisterModel? signUpModel;

  Future<void> signUp({
    required File? image,
    required String phoneNumber,
    required String name,
    required String email,
    required String password,
    required String age,
  }) async {
    emit(SignUpLoading());
    var result = await registerRepo.register(
      data: FormData.fromMap({
        if (image != null) "image": await MultipartFile.fromFile(image.path),
        "phone": phoneNumber,
        "name": name,
        "email": email,
        "password": password,
        "center_id": 1,
        "city_id": 1,
        "age" : age
      }),
    );
    return result.fold((failure) {
      emit(SignUpError(failure.errMessage));
    }, (data) async {
      if (data.status == true) {
        signUpModel = data;
        final resolvedEmail = data.data?.resolvedEmail ?? email;
        await CacheHelper.saveData(key: "email", value: resolvedEmail);
        emit(SignUpSuccess(data));
      } else {
        emit(SignUpError(data.message.toString()));
      }
    });
  }

  void clearData() {
    nameCon.clear();
    ageCon.clear();
    mobileCon.clear();
    passCon.clear();
    confirmPassCon.clear();
    emailCon.clear();
    profileImage = null;

    emit(ClearDataSuccess());
  }
}
