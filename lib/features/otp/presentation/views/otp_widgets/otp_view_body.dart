 import 'dart:async';
import 'package:by3ly/features/otp/presentation/views/otp_widgets/pin_code_text_field_widget.dart';
import 'package:by3ly/features/otp/presentation/views/otp_widgets/resend_otp_button.dart';
import 'package:by3ly/main_importants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/shared_widgets/custom_global_app_bar.dart';
import '../../view_model/otp_cubit.dart';
import 'otp_button.dart';
import 'otp_texts_widget.dart';

class OtpViewBody extends StatefulWidget {
  const OtpViewBody({super.key, required this.email});
  final String email;
  @override
  State<OtpViewBody> createState() => _OtpViewBodyState();
}

class _OtpViewBodyState extends State<OtpViewBody> {

  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  // Timer variables
  late Timer _timer;
  int _secondsRemaining = 60;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    startTimer(); // Start countdown when view loads
    super.initState();
  }
  @override
  void dispose() {
    errorController?.close();
    _timer.cancel(); // Cancel timer to avoid memory leaks
    super.dispose();
  }
  bool _showResend = false;
  void startTimer() {
    _secondsRemaining = 60;
    _showResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() {
          _showResend = true;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void resendCode() {
    context.read<OtpCubit>().resendOtp(
        email: CacheHelper.getData(key: "email"));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(LocaleKeys.verificationCodeResent)),
    );
    startTimer(); // Restart timer after resending
  }

  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const CustomGlobalAppbarWidget(
          arrowBackOrNot: true,
        ),
        Form(
          key: formKey,
          child: Padding(
            padding:   EdgeInsets.all(20.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OtpTexts(email: widget.email,),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: CustomPinCodeField(
                    controller: textEditingController,
                    errorController: errorController,
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                  ),
                ),
                  ResendOtpButton(
                    secondsRemaining: _secondsRemaining,
                    showResend: _showResend,
                    onPressed: resendCode,
                  ),
                Gap(20.h),
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
