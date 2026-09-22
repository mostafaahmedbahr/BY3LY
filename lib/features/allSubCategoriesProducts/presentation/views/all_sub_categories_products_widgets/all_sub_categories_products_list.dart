import 'package:by3ly/main_importants.dart';
import '../../../../../core/shared_widgets/container_search_widget.dart';
import '../../../data/models/all_sub_categories_products_model.dart';
import 'all_sub_categories_products_list_item.dart';

class AllSubCategoriesProductsList extends StatelessWidget {
  const AllSubCategoriesProductsList(
      {super.key, required this.allSubCategoriesProductsList});

  final List<Products> allSubCategoriesProductsList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0.r),
      child: Column(
        children: [
          const ContainerSearchWidget(),
          Gap(20.h),
          Expanded(
            child: GridView.builder(
              gridDelegate:   SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 0.65,
              ),
              itemCount: allSubCategoriesProductsList.length,
              itemBuilder: (context, index) {
                return AllSubCategoriesProductsListItem(
                  product: allSubCategoriesProductsList[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
