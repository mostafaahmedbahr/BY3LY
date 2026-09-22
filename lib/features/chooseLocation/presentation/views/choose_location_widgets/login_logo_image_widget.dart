
import '../../../../../main_importants.dart';
class LoginLogoImageWidget extends StatelessWidget {
  const LoginLogoImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.mainColor,
      ),
        height: 65.h,
        width: 153.w,
        child: Image.asset(AppImages.logo2,
        fit: BoxFit.cover,
        ),
    );
  }
}
