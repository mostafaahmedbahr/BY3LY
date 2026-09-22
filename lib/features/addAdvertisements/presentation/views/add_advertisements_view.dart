import 'package:by3ly/features/addAdvertisements/presentation/views/add_advertisements_widgets/add_advertisements_view_body.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../main_importants.dart';

class AddAdvertisementsView extends StatelessWidget {
  const AddAdvertisementsView({super.key, required this.categoryId, required this.subCategoryId});
  final int categoryId;
  final int subCategoryId;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title:   Text(LocaleKeys.addAnAd.tr(),style: const TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold
        ),),
      ),
      body:   AddAdvertisementsViewBody(
        categoryId: categoryId,
        subCategoryId: subCategoryId,
      ),
    ));
  }
}
