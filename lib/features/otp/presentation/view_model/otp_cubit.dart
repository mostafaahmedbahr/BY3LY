import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/app_services/local_services/cache_token.dart';
import 'package:by3ly/core/utils/app_consts/storage_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/otp_model.dart';
import '../../data/models/resend_otp_model.dart';
import '../../data/repos/otp_repos.dart';
import 'otp_states.dart';


class OtpCubit extends Cubit<OtpStates> {
  OtpCubit(this.otpRepos) : super(OtpInitState());


  final OtpRepos otpRepos;
  OtpModel? otpModel;

  Future<void> verifyOtp({
    required String otp, required String email, required String deviceToken
}) async {
    emit(VerifyOtpLoadingState());
    var result = await otpRepos.verifyOtp(
        otp: otp,
      email: email,
      deviceToken: deviceToken,
    );
    return result.fold((failure) {
      emit(VerifyOtpErrorState(failure.errMessage));
    }, (data) async {
      if(data.status == true){
        otpModel = data;
        // Save token after OTP success (supports token in data OR data.user)
        final token = data.data?.resolvedToken;
        if (token != null && token.isNotEmpty && token != 'null') {
          try {
            await CacheTokenManger.saveUserToken(token);
          } catch (e) {
            // Secure storage is best-effort — the in-memory token still
            // authenticates the user this session.
            debugPrint('OtpCubit: secure token persist failed — $e');
          }
          await CacheHelper.saveData(key: StorageKeys.userToken, value: token);
          await CacheHelper.saveData(key: StorageKeys.isGuest, value: false);
        }
        final emailToSave = data.data?.resolvedEmail ?? email;
        if (emailToSave.isNotEmpty) {
          await CacheHelper.saveData(key: "email", value: emailToSave);
        }
         emit(VerifyOtpSuccessState(data));
      }else{
        emit(VerifyOtpErrorState(data.message.toString()));
      }
    });
  }


  ResendOtpModel? resendOtpModel;
  Future<void> resendOtp({
  required String email
  }) async {
    emit(ResendOtpLoadingState());
    var result = await otpRepos.resendOtp(
      email: email,
    );
    return result.fold((failure) {
      emit(ResendOtpErrorState(failure.errMessage));
    }, (data) {
      if(data.status == true){
        resendOtpModel = data;
        emit(ResendOtpSuccessState(data));
      }else{
        emit(ResendOtpErrorState(data.message.toString()));

      }
    });
  }
}
