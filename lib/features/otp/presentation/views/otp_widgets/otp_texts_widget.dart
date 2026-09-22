import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';


class OtpTexts extends StatelessWidget {
  const OtpTexts({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr(LocaleKeys.confirmEmail),
          style: AppStyles.textStyle20W600Black),
        Gap(10.h),
        Row(
          children: [
            Text(context.tr(LocaleKeys.weHaveSentTo),
                style: AppStyles.textStyle14W500Gray),
            Gap(5.w),
            Text(
                email=="" ? CacheHelper.getData(key: "email") : email,
                style: AppStyles.textStyle14W500Gray),
          ],
        ),
      ],
    );
  }
}
