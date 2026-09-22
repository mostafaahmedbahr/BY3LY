import 'package:easy_localization/easy_localization.dart';
import '../../../../main_importants.dart';
import 'all_sub_categories_products_widgets/all_sub_categories_products_view_body.dart';

class AllSubCategoriesProductsView extends StatelessWidget {
  const AllSubCategoriesProductsView(
      {super.key, required this.subCategoryId, required this.subCategoryName});

  final int subCategoryId;
  final String subCategoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text(
          "${context.tr(LocaleKeys.allProducts)} ( $subCategoryName )",
          style: const TextStyle(
              color: AppColors.yellowColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: AllSubCategoriesProductsViewBody(
        subCategoryId: subCategoryId,
      ),
    );
  }
}
