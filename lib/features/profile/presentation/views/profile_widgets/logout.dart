import 'package:easy_localization/easy_localization.dart';

import '../../../../../main_importants.dart';
import 'logout_dialog.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showLogoutDialog(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.redColor.withValues(alpha: 0.35),
            ),
            color: AppColors.redColor.withValues(alpha: 0.06),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppImages.logout,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  AppColors.redColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.signOut.tr(),
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.redColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
