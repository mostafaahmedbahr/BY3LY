import 'dart:async';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinCodeField extends StatefulWidget {
  const CustomPinCodeField({
    super.key,
    required this.controller,
    this.errorController,
    this.onChanged,
  });

  final TextEditingController controller;
  final StreamController<ErrorAnimationType>? errorController;
  final ValueChanged<String>? onChanged;

  @override
  CustomPinCodeFieldState createState() => CustomPinCodeFieldState();
}

class CustomPinCodeFieldState extends State<CustomPinCodeField> {
  String currentText = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: PinCodeTextField(
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(16),
            fieldHeight: 56.h,
            fieldWidth: 46.w,
            activeColor: AppColors.mainColor,
            selectedColor: AppColors.mainColor,
            selectedFillColor: AppColors.mainColor.withValues(alpha: 0.12),
            activeFillColor: AppColors.surface,
            inactiveFillColor: AppColors.surface,
            inactiveColor: AppColors.border,
            disabledColor: AppColors.border,
            errorBorderColor: AppColors.redColor,
          ),
          enableActiveFill: true,
          animationDuration: const Duration(milliseconds: 240),
          errorAnimationController: widget.errorController,
          controller: widget.controller,
          onCompleted: (_) {},
          beforeTextPaste: (_) => true,
          onChanged: (value) {
            setState(() => currentText = value);
            widget.onChanged?.call(value);
          },
          appContext: context,
        ),
      ),
    );
  }
}
