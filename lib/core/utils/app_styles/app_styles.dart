import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors/app_colors.dart';

class AppStyles {
  static final textStyle20BoldGreen = TextStyle(
    color: AppColors.accent,
    fontWeight: FontWeight.bold,
    fontSize: 20.sp,
  );
  static TextStyle get textStyle20W600Black => TextStyle(
    color: AppColors.text,
    fontWeight: FontWeight.w600,
    fontSize: 20.sp,
  );
  static const textStyle14W500White = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: Colors.white,
  );
  static TextStyle get textStyle14W500Gray => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static TextStyle get textStyle10W400Gray => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: AppColors.textSecondary,
  );

  static TextStyle get textStyle10W400Green => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: AppColors.accent,
  );

  static const textStyle10W400Yellow = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: AppColors.yellowColor,
  );

  static TextStyle get textStyle14W500Black => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.text,
  );

  static TextStyle get textStyle16W500Black => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.text,
  );

  static TextStyle get textStyle12W600Gary => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static TextStyle get textStyle10W600Black => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 10,
    color: AppColors.text,
  );

  static TextStyle get textStyle16W600Black => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.text,
  );

  static TextStyle get textStyle16W600Green => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.accent,
  );

  static const textStyle15 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 15,
    color: Colors.white,
  );
  static const textStyle16 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: Colors.white,
  );

  static const textStyle23 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 23,
    color: Colors.white,
  );

  static const textStyle18 = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: Colors.white,
  );

  static const textStyle20 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: Colors.white,
  );

  static const textStyle24 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 24,
    color: Colors.white,
  );

  static const textStyle30 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 30,
    color: Colors.white,
  );
}
