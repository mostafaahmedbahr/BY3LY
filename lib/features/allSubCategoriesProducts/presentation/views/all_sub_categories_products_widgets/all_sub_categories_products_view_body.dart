import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/features/allSubCategoriesProducts/data/repos/all_sub_categories_products_repos_imple.dart';
import 'package:by3ly/features/allSubCategoriesProducts/presentation/view_model/all_sub_categories_products_cubit.dart';
import 'package:by3ly/features/allSubCategoriesProducts/presentation/view_model/all_sub_categories_products_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/app_services/remote_services/service_locator.dart';
import '../../../../seeAllBestView/presentation/views/see_all_best_view_widgets/sell_all_best_view_loading.dart';
import 'all_sub_categories_products_list.dart';

class AllSubCategoriesProductsViewBody extends StatelessWidget {
  const AllSubCategoriesProductsViewBody(
      {super.key, required this.subCategoryId});

  final int subCategoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllSubCategoriesProductsCubit(
          getIt.get<AllSubCategoriesProductsReposImpl>())
        ..getAllSubCategoriesProducts(subCategoryId: subCategoryId),
      child: BlocBuilder<AllSubCategoriesProductsCubit,
          AllSubCategoriesProductsStates>(
        builder: (context, state) {
          var sellAllBestViewCubit =
              context.read<AllSubCategoriesProductsCubit>();
          if (state is GetAllSubCategoriesProductsLoading) {
            return const SellAllBestViewLoading();
          }
          if (state is GetAllSubCategoriesProductsError) {
            return CustomErrorWidget(
                error: state.message.toString(), onTap: () {});
          }
          return AllSubCategoriesProductsList(
            allSubCategoriesProductsList:
                sellAllBestViewCubit.allSubCategoriesProductsList,
          );
        },
      ),
    );
  }
}
