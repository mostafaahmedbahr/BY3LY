import '../../data/models/otp_model.dart';
import '../../data/models/resend_otp_model.dart';

abstract class OtpStates{}

class OtpInitState extends OtpStates{}

class VerifyOtpLoadingState extends OtpStates{}
class VerifyOtpSuccessState extends OtpStates{
  final OtpModel otpModel;
  VerifyOtpSuccessState(this.otpModel);
}
class VerifyOtpErrorState extends OtpStates{
  final String error;
  VerifyOtpErrorState(this.error);
}

class ResendOtpLoadingState extends OtpStates{}
class ResendOtpSuccessState extends OtpStates{
  final ResendOtpModel resendOtpModel;
  ResendOtpSuccessState(this.resendOtpModel);
}
class ResendOtpErrorState extends OtpStates{
  final String error;
  ResendOtpErrorState(this.error);
}