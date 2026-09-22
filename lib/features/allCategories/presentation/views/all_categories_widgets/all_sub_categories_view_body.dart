import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/features/allSubCategories/presentation/views/all_sub_categories_widgets/main_category_info.dart';

import '../../../../../main_importants.dart';
import '../../../../allSubCategories/data/repos/all_sub_categories_repos_imple.dart';
import '../../../../allSubCategories/presentation/view_model/all_sub_categories_cubit.dart';
import '../../../../allSubCategories/presentation/view_model/all_sub_categories_states.dart';
import '../../../../allSubCategories/presentation/views/all_sub_categories_widgets/all_sub_categories_list.dart';

class AllSubCategoriesViewBody extends StatelessWidget {
  const AllSubCategoriesViewBody({super.key,
      required this.mainCategoryId, required this.mainCategoryName, required this.mainCategoryImage,
     });

  final int mainCategoryId;
  final String mainCategoryName;
  final String mainCategoryImage;

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context)=>AllSubCategoriesCubit(
          getIt.get<AllSubCategoriesRepoImpl>())
        ..getAllSubCategories(categoryId: mainCategoryId),
      child: BlocBuilder<AllSubCategoriesCubit , AllSubCategoriesStates>(
        builder: (BuildContext context, state) {
          var allSubCategoriesCubit = context.read<AllSubCategoriesCubit>();
          return
            state is GetAllSubCategoriesLoading ?
            const CustomLoading()
            : state is GetAllSubCategoriesError ?
              CustomErrorWidget(error: state.message.toString(),
                  onTap: (){}) :
            Padding(
            padding:   EdgeInsets.all(20.0.r),
            child: ListView(
              children: [
                MainCategoryInfo(
                    mainCategoryName: mainCategoryName.toString() ,
                    mainCategoryImage: mainCategoryImage.toString() ,
                  mainCategoryTypesCount: allSubCategoriesCubit.allSubCategoriesList.length,

                ),
                Gap(20.h),
                AllSubCategoriesList(
                  categoryId: mainCategoryId,
                  allSubCategoriesList: AllSubCategoriesCubit.get(context).allSubCategoriesList,
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
