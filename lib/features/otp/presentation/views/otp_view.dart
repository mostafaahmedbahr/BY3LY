import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/otp/presentation/views/otp_widgets/otp_view_body.dart';
import 'package:flutter/material.dart';

/// Matches the login / register screens: a zero-height `secondColor` bar
/// above the branded hero, no separate toolbar — the hero carries the
/// back arrow itself.
class OtpView extends StatelessWidget {
  const OtpView({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        toolbarHeight: 0,
        scrolledUnderElevation: 0,
      ),
      body: OtpViewBody(email: email),
    );
  }
}
