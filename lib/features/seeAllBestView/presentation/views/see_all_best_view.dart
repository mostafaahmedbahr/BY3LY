 import 'package:by3ly/features/seeAllBestView/presentation/views/see_all_best_view_widgets/see_all_best_view_body.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../main_importants.dart';

class SeeAllView extends StatelessWidget {
  const SeeAllView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title:   Text(context.tr(LocaleKeys.bestView),style: const TextStyle(
            color: AppColors.yellowColor,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: const SeeAllBestViewBody(),
    ));
  }
}
