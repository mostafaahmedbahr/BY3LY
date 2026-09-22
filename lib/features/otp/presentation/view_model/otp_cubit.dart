import '../../../../main_importants.dart';
import '../../data/models/otp_model.dart';
import '../../data/models/resend_otp_model.dart';
import '../../data/repos/otp_repos.dart';
import 'otp_states.dart';


class OtpCubit extends Cubit<OtpStates> {
  OtpCubit(this.otpRepos) : super(OtpInitState());


  OtpRepos? otpRepos;
  OtpModel? otpModel;

  Future<void> verifyOtp({
    required String otp, required String email
}) async {
    emit(VerifyOtpLoadingState());
    var result = await otpRepos!.verifyOtp(
        otp: otp,
      email: email,
    );
    return result.fold((failure) {
      emit(VerifyOtpErrorState(failure.errMessage));
    }, (data) {
      if(data.status == true){
        otpModel = data;
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
    var result = await otpRepos!.resendOtp(
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
