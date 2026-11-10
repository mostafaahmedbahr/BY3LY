import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Terms & conditions footnote below the CTA stack.
class LoginTermsWidget extends StatelessWidget {
  const LoginTermsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            context.tr(LocaleKeys.loginTermsMsg1),
            style: AppStyles.textStyle10W400Gray,
          ),
          Gap(4.w),
          InkWell(
            onTap: () => context.pushNamed(Routes.termsView),
            borderRadius: BorderRadius.circular(4),
            child: Text(
              context.tr(LocaleKeys.loginTermsMsg2),
              style: AppStyles.textStyle10W400Green.copyWith(
                decoration: TextDecoration.underline,
                decorationColor:
                    AppColors.mainColor.withValues(alpha: 0.45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
