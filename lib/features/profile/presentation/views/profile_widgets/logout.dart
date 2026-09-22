import 'package:easy_localization/easy_localization.dart';

import '../../../../../main_importants.dart';
import 'logout_dialog.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:   EdgeInsets.symmetric(vertical: 5.h),
      child: InkWell(
        onTap: () {
          showLogoutDialog(context);
        },
        child: Card(
          shadowColor: AppColors.redColor,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: const Color(0xffF8F8F8),
            ),
            child: Row(
              children: [
                SvgPicture.asset(AppImages.logout),
                Gap(20.w),
                Text(LocaleKeys.signOut.tr(),
                    style: AppStyles.textStyle14W500White.copyWith(
                      color: AppColors.redColor,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
