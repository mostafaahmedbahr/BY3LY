import 'package:by3ly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../models/otp_model.dart';
import '../models/resend_otp_model.dart';

abstract class OtpRepos {

  Future<Either<Failure, OtpModel>> verifyOtp(
      {required String otp, required String email});

  Future<Either<Failure, ResendOtpModel>> resendOtp(
      {required String email});

}
