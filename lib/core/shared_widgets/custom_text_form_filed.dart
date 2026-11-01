import 'package:by3ly/main_importants.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors/app_colors.dart'; // Import for color consistency

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final bool? obscureText;
  final Widget? icon;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? suffixIcon;
  final void Function()? onPressed;
  final void Function(String)? onChanged;
  final String? hintText;
  final String? labelText;
  final int? maxLines;
  final double? radius;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final Color? fillColor;
  final Color? borderColor;
  final Color? hintColor;
  final int? maxLength;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;

  const CustomTextFormField({
    Key? key,
    this.controller,
    this.obscureText,
    this.icon,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.onPressed,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.maxLines,
    this.keyboardType,
    this.validator,
    this.readOnly,
    this.maxLength,
    this.fillColor,
    this.borderColor,
    this.hintColor,
    this.radius = 10.0,
    this.onFieldSubmitted,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveFillColor = fillColor ?? AppColors.surface;
    final textColor =
        ThemeData.estimateBrightnessForColor(effectiveFillColor) ==
                Brightness.dark
            ? AppColors.whiteColor
            : AppColors.blackColor;
    return TextFormField(
      maxLength: maxLength,
      style: TextStyle(color: textColor),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: obscureText ?? false,
      readOnly: readOnly ?? false,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType ?? TextInputType.text,
      onChanged: onChanged,
      validator: validator,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: AppColors.accent), // Consistent label style
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        prefixIcon: Padding(
          padding:   EdgeInsets.all(8.0.r),
          child: prefixIcon,
        ),
        prefix: prefix,
        icon: icon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: effectiveFillColor,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 10),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 10),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 10),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.accent,
          ),
        ),
        hintText: hintText,

        hintStyle: TextStyle(
          fontSize: 14,
          color: hintColor ?? AppColors.textSecondary,
        ),
      ),
    );
  }
}
