import 'dart:io';
import 'package:by3ly/features/register/presentation/view_model/register_states.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../main_importants.dart';
import '../../data/models/register_model.dart';
import '../../data/repos/register_repo.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit(this.registerRepo) : super(RegisterInitState());

  RegisterRepo? registerRepo;

  static RegisterCubit get(context) => BlocProvider.of(context);

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

  var passCon = TextEditingController();
  var confirmPassCon = TextEditingController();
  var emailCon = TextEditingController();
  var mobileCon = TextEditingController();
  var nameCon = TextEditingController();

  // File? file;
  // Future uploadOnlyImage() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowedExtensions: ["jpg", "png", "jpeg"],
  //     type: FileType.custom,
  //   );
  //   file = File(result?.files.single.path ?? "");
  //   debugPrint("---------- upload is done ------------");
  //   if(file!.path !=""){
  //     emit(UploadImageSuccessState());
  //   }
  //
  // }

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
  }) async {
    emit(SignUpLoading());
    var result = await registerRepo!.register(
      data: FormData.fromMap({
        if (image != null) "image": await MultipartFile.fromFile(image.path),
        "phone": phoneNumber,
        "name": name,
        "email": email,
        "password": password,
      }),
    );
    return result.fold((failure) {
      emit(SignUpError(failure.errMessage));
    }, (data) async {
      if (data.status == true) {
        signUpModel = data;
        await CacheTokenManger.saveUserToken("${data.data!.user!.token}");
        CacheHelper.saveData(key: "email", value: "${data.data!.user!.email}");
        emit(SignUpSuccess(data));
      } else {
        emit(SignUpError(data.message.toString()));
      }
    });
  }

  void clearData() {
    nameCon.clear();
    mobileCon.clear();
    passCon.clear();
    confirmPassCon.clear();
    emailCon.clear();
    profileImage = null;

    emit(ClearDataSuccess());
  }
}
