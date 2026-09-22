import 'dart:io';
import 'package:by3ly/features/profile/data/models/profile_data_model.dart';
import 'package:by3ly/features/updateProfile/data/models/update_profile_data_model.dart';
import 'package:by3ly/features/updateProfile/data/repos/update_profile_data_repo.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_states.dart';
import 'package:dio/dio.dart';
 import 'package:image_picker/image_picker.dart';

import '../../../../main_importants.dart';

class UpdateProfileDataCubit extends Cubit<UpdateProfileDataStates> {
  UpdateProfileDataCubit(this.updateProfileDataRepos) : super(UpdateProfileDataInitState());

  static UpdateProfileDataCubit get(context) => BlocProvider.of(context);


  UpdateProfileDataRepos? updateProfileDataRepos;


  UpdateProfileDataModel? updateProfileDataModel;

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
      if (fullName != null && fullName.isNotEmpty)
        "name": fullName,
      if (email != null && email.isNotEmpty)
        "email": email,
      if (phoneNumber != null && phoneNumber.isNotEmpty)
        "phone": phoneNumber,

    };

    FormData formData = FormData.fromMap(formMap);
    var result = await updateProfileDataRepos!.updateProfileData(data: formData);
    return result.fold((failure) {
      emit(UpdateProfileDataErrorState(failure.errMessage));
    }, (data) async {
      updateProfileDataModel = data;
      emit(UpdateProfileDataSuccessState(data));
    });
  }

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



  var nameCon = TextEditingController();
  var emailCon = TextEditingController();
  var phoneCon = TextEditingController();


  void initControllers(ProfileModel profile) {
    nameCon.text = profile.data!.user!.name ?? '';
    emailCon.text = profile.data!.user!.email ?? '';
    phoneCon.text = profile.data!.user!.phone ?? '';

  }


}