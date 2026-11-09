import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/features/allSubCategories/data/repos/all_sub_categories_repos_imple.dart';
import 'package:by3ly/features/allSubCategories/presentation/view_model/all_sub_categories_cubit.dart';
import 'package:by3ly/features/allSubCategories/presentation/view_model/all_sub_categories_states.dart';
import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'all_sub_categories_list.dart';
import 'main_category_info.dart';

class AllSubCategoriesViewBody extends StatelessWidget {
  const AllSubCategoriesViewBody({
    super.key,
    required this.mainCategoryId,
    required this.mainCategoryName,
    required this.mainCategoryImage,
  });

  final int mainCategoryId;
  final String mainCategoryName;
  final String mainCategoryImage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllSubCategoriesCubit(
        getIt.get<AllSubCategoriesRepoImpl>(),
      )..getAllSubCategories(categoryId: mainCategoryId),
      child: BlocBuilder<AllSubCategoriesCubit, AllSubCategoriesStates>(
        builder: (context, state) {
          final cubit = context.read<AllSubCategoriesCubit>();
          if (state is GetAllSubCategoriesLoading) {
            return const Center(child: CustomLoading());
          }
          if (state is GetAllSubCategoriesError) {
            return CustomErrorWidget(
              error: state.message.toString(),
              onTap: () => cubit.getAllSubCategories(
                categoryId: mainCategoryId,
                forceRefresh: true,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                MainCategoryInfo(
                  mainCategoryName: mainCategoryName,
                  mainCategoryImage: mainCategoryImage,
                  mainCategoryTypesCount: cubit.allSubCategoriesList.length,
                ),
                const SizedBox(height: 20),
                AllSubCategoriesList(
                  categoryId: mainCategoryId,
                  allSubCategoriesList: cubit.allSubCategoriesList,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
