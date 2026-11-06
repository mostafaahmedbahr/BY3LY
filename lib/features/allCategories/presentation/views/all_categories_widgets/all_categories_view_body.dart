
import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/cubit.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/states.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../../main_importants.dart';
import '../../../../profile/presentation/views/profile_widgets/profile_view_body_list_item_widget.dart';
import 'get_all_categories_loading_list.dart';

class AllCategoriesViewBody extends StatelessWidget {
  const AllCategoriesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllCategoriesCubit, AllCategoriesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = context.read<AllCategoriesCubit>();

        if (state is GetAllCategoriesLoading) {
          return const GetAllCategoriesLoadingList();
        }

        if (state is GetAllCategoriesError) {
          return CustomErrorWidget(
            error: state.message.toString(),
            onTap: () {
              // استدعِ دالة إعادة تحميل الأقسام الموجودة في Cubit هنا.
            },
          );
        }

        final categories = cubit.allCategoriesList;

        if (categories.isEmpty) {
          return const Center(
            child: Text('لا توجد أقسام حالياً'),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 18.w,
          ),
          child: AnimationLimiter(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 450),
                  child: SlideAnimation(
                    verticalOffset: 25,
                    child: FadeInAnimation(
                      child: ProfileViewBodyListItemWidget(
                        title: category.name.toString(),
                        subtitle:
                        '${category.subCategories?.length ?? 0} قسم فرعي',
                        image: category.image.toString(),
                        svg: false,
                        onTap: () {
                          context.pushNamed(
                            Routes.allSubCategoriesView,
                            arguments: {
                              "mainCategoryName": category.name.toString(),
                              "mainCategoryId": category.id,
                              "mainCategoryImage": category.image.toString(),
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 5.h);
              },
            ),
          ),
        );
      },
    );
  }
}
