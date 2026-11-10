import 'dart:async';

import 'package:by3ly/core/shared_widgets/custom_global_app_bar.dart';
import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../view_model/otp_cubit.dart';
import 'otp_button.dart';
import 'otp_texts_widget.dart';
import 'pin_code_text_field_widget.dart';
import 'resend_otp_button.dart';

class OtpViewBody extends StatefulWidget {
  const OtpViewBody({super.key, required this.email});

  final String email;

  @override
  State<OtpViewBody> createState() => _OtpViewBodyState();
}

class _OtpViewBodyState extends State<OtpViewBody> {
  final TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  final formKey = GlobalKey<FormState>();

  Timer? _timer;
  int _secondsRemaining = 60;
  bool _showResend = false;

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
  }

  @override
  void dispose() {
    errorController?.close();
    _timer?.cancel();
    textEditingController.dispose();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel();
    _secondsRemaining = 60;
    _showResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _showResend = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void resendCode() {
    context.read<OtpCubit>().resendOtp(
          email: widget.email.isEmpty
              ? (CacheHelper.getData(key: 'email') ?? '').toString()
              : widget.email,
        );
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const CustomGlobalAppbarWidget(arrowBackOrNot: true),
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OtpTexts(email: widget.email),
                const SizedBox(height: 6),
                CustomPinCodeField(
                  controller: textEditingController,
                  errorController: errorController,
                  onChanged: (_) {},
                ),
                ResendOtpButton(
                  secondsRemaining: _secondsRemaining,
                  showResend: _showResend,
                  onPressed: resendCode,
                ),
                const SizedBox(height: 18),
                OtpButton(
                  formKey: formKey,
                  controller: textEditingController,
                  email: widget.email,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
