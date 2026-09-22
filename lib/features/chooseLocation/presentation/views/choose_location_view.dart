import 'package:easy_localization/easy_localization.dart';
import '../../../../main_importants.dart';
import 'choose_location_widgets/choose_location_view_body.dart';

class ChooseLocationView extends StatelessWidget {
  const ChooseLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(CacheTokenManger.userToken);
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10
            ),
            child: SvgPicture.asset(AppImages.currentLocation),
          ),
        ],
        title:   Text(LocaleKeys.chooseYourLocation.tr(),style: const TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: const ChooseLocationViewBody(),
    ));
  }
}
