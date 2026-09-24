import 'package:bloc/bloc.dart';
import 'package:by3ly/features/login/presentation/view_model/login_states.dart';
import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
 import '../../../../core/app_services/local_services/cache_helper.dart';
import '../../../../core/app_services/local_services/cache_token.dart';
import '../../../../lang/locale_keys.dart';
import '../../data/models/login_model.dart';
import '../../data/repos/login_repos.dart';
import 'package:url_launcher/url_launcher.dart';


class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(this.loginRepo) : super(LoginInitState());


  var phoneCon = TextEditingController();
  var emailCon = TextEditingController();
  var passwordCon = TextEditingController();



  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  LoginRepo? loginRepo;
  LoginModel? loginModel;
  bool isPasswordVisible = true;

  void changePasswordVisible()
  {
    isPasswordVisible = !isPasswordVisible;
    emit(ChangePasswordVisibleState());
  }

  Future<void> login({
    required String phone , required String password , required String deviceToken
})
  async {
    emit(LoginLoadingState());
    var result = await loginRepo!.login(phone: phone, password: password, deviceToken: deviceToken);
    return result.fold((failure) {
      emit(LoginErrorState(failure.errMessage));
    }, (data) async {
      if (data.status==true){
        if(data.data!.isActive==true){
          loginModel = data;
          await CacheTokenManger.saveUserToken("${data.data!.user!.token}");
          CacheHelper.saveData(key: "email", value: data.data!.user!.email);
          CacheHelper.saveData(key: "isActive", value: data.data!.isActive);
          emit(LoginSuccessState(data));
        }else if(data.data!.isActive==false){
          CacheHelper.saveData(key: "email", value: data.data!.user!.email);
          CacheHelper.saveData(key: "requiresOtp", value: data.data!.requiresOtp);
          CacheHelper.saveData(key: "isActive", value: data.data!.isActive);
        }
      }
      else{
        emit(LoginErrorState(data.message.toString()));
      }
    });
  }


  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw context.tr(LocaleKeys.theLinkCannotBeOpened);
    }
  }


}
