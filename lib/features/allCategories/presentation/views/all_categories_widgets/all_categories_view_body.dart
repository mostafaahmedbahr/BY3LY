import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/cubit.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/states.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../../main_importants.dart';
import '../../../../profile/presentation/views/profile_widgets/profile_view_body_list_item_widget.dart';
import 'get_all_categories_loading_list.dart';

class AllCategoriesViewBody extends StatelessWidget {
  const AllCategoriesViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllCategoriesCubit, AllCategoriesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var allCategoriesCubit = context.read<AllCategoriesCubit>();
        if (state is GetAllCategoriesLoading) {
          return const GetAllCategoriesLoadingList();
        } else if (state is GetAllCategoriesError) {
          return CustomErrorWidget(
              error: state.message.toString(), onTap: () {});
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
          child: AnimationLimiter(
            child: ListView.separated(
              itemCount: allCategoriesCubit.allCategoriesList.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    horizontalOffset: 2.0,
                    child: FadeInAnimation(
                      child: ProfileViewBodyListItemWidget(
                        onTap: () {
                          final category =
                              allCategoriesCubit.allCategoriesList[index];
                          context.pushNamed(
                            Routes.allSubCategoriesView,
                            arguments: {
                              "mainCategoryName": category.name.toString(),
                              "mainCategoryId": category.id,
                              "mainCategoryImage": category.image.toString(),
                            },
                          );
                        },
                        title:
                            "${allCategoriesCubit.allCategoriesList[index].name} "
                            "( ${allCategoriesCubit.allCategoriesList[index].subCategories!.length} )",
                        image: allCategoriesCubit.allCategoriesList[index].image
                            .toString(),
                        svg: false,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Gap(10.h);
              },
            ),
          ),
        );
      },
    );
  }
}
