import 'dart:async';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../main_importants.dart';

class CustomPinCodeField extends StatefulWidget {
  final TextEditingController controller;
  final StreamController<ErrorAnimationType>? errorController;
  final Function(String)? onChanged;

  const CustomPinCodeField({
    super.key,
    required this.controller,
    this.errorController,
    this.onChanged,
  });

  @override
  CustomPinCodeFieldState createState() => CustomPinCodeFieldState();
}

class CustomPinCodeFieldState extends State<CustomPinCodeField> {
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:   EdgeInsets.symmetric(vertical: 40.h),
      child: PinCodeTextField(
        validator: (v) {
          if (v!.length < 4) {
            return context.tr(LocaleKeys.numberMustBeAtLeast4Digits);
          } else {
            return null;
          }
        },
        length: 4,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          activeColor: AppColors.mainColor,
          selectedColor: AppColors.mainColor,
          selectedFillColor: AppColors.mainColor,
          inactiveFillColor: AppColors.whiteColor,
          inactiveColor: AppColors.greyColor,
          disabledColor: AppColors.mainColor,
          errorBorderColor: AppColors.mainColor,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 40.h,
          fieldWidth: 40.w,
          activeFillColor: Colors.white,
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: AppColors.whiteColor,
        enableActiveFill: true,
        errorAnimationController: widget.errorController,
        controller: widget.controller,
        onCompleted: (v) {

        },
        onChanged: (value) {
          setState(() {
            currentText = value;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        beforeTextPaste: (text) {

          return true; // Allow paste
        },
        appContext: context,
      ),
    );
  }
}
