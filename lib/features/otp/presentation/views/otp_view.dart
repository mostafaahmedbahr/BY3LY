import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors/app_colors.dart';
import 'otp_widgets/otp_view_body.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: OtpViewBody(
        email: email,
      ),
    );
  }
}
//8523