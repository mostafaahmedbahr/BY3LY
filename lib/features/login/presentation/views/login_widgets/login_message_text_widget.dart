import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Welcome copy above the form: brand wordmark inline with the greeting,
/// tagline underneath.
class LoginMessageTextWidget extends StatelessWidget {
  const LoginMessageTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.tr(LocaleKeys.loginMsg1),
              style: AppStyles.textStyle16W600Black,
            ),
            Gap(5.w),
            Text(
              context.tr(LocaleKeys.appName),
              style: AppStyles.textStyle20BoldGreen,
            ),
          ],
        ),
        Gap(8.h),
        Text(
          context.tr(LocaleKeys.loginMsg2),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5,
          ),
        ),
        Gap(22.h),
      ],
    );
  }
}
