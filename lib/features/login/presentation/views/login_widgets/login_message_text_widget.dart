import 'package:easy_localization/easy_localization.dart';
import '../../../../../main_importants.dart';


class LoginMessageTextWidget extends StatelessWidget {
  const LoginMessageTextWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return   Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.tr(LocaleKeys.loginMsg1)),
            Gap(5.w),
            Text(context.tr(LocaleKeys.appName),
            style:   AppStyles.textStyle20BoldGreen,
            ),
          ],
        ),
        Gap(10.h),
        Text(context.tr(LocaleKeys.loginMsg2),
        style: const TextStyle(
          color: AppColors.greyColor
        ),),
        Gap(40.h),
      ],
    );
  }
}
