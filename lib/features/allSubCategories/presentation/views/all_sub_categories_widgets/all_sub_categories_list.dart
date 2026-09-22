import 'package:by3ly/features/allSubCategories/data/models/all_sub_categories_model.dart';
import '../../../../../main_importants.dart';

class AllSubCategoriesList extends StatelessWidget {
  const AllSubCategoriesList({super.key,
    required this.allSubCategoriesList,  required this.categoryId});
  final List<SubCategories> allSubCategoriesList;

  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return   GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:   SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0.h,
        mainAxisSpacing: 8.0.w,
        childAspectRatio: 1.0,
      ),
      itemCount: allSubCategoriesList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            if(allSubCategoriesList[index].productsCount==0){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("لا يوجد منتجات في هذا القسم"),
                ),
              );
            }else{
              context.pushNamed(Routes.allSubCategoriesProductsView,
                  arguments: {
                    "subCategoryId" : allSubCategoriesList[index].id!,
                    "subCategoryName" : allSubCategoriesList[index].name.toString(),
                  });
            }

          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                    color: AppColors.mainColor
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  allSubCategoriesList[index].name.toString(),
                  style:   TextStyle(color: Colors.black87, fontSize: 18.sp),
                ),
                  Text("( ${allSubCategoriesList[index].productsCount} منتج )"),
              ],
            ),
          ),
        );
      },
    );
  }
}
