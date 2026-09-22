 import 'package:by3ly_app/features/profile/presentation/views/profile_widgets/profile_view_body_2.dart';
import 'package:easy_localization/easy_localization.dart';
 import '../../../../main_importants.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    logSuccess(CacheTokenManger.userToken);
    logSuccess("ProfileView");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title:   Text(context.tr(LocaleKeys.account),style: const TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: const ProfileViewBody2(),
    );
  }
}
