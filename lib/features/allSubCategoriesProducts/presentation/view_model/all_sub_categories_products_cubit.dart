import 'package:by3ly/features/allSubCategoriesProducts/data/repos/all_sub_categories_products_repos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/all_sub_categories_products_model.dart';
import 'all_sub_categories_products_states.dart';

class AllSubCategoriesProductsCubit
    extends Cubit<AllSubCategoriesProductsStates> {
  AllSubCategoriesProductsCubit(this.allSubCategoriesProductsRepos)
      : super(AllSubCategoriesProductsInitState());

  static AllSubCategoriesProductsCubit get(BuildContext context) =>
      BlocProvider.of<AllSubCategoriesProductsCubit>(context);

  final AllSubCategoriesProductsRepos allSubCategoriesProductsRepos;
  AllSubCategoriesProductsModel? allSubCategoriesProductsModel;

  List<Products> allSubCategoriesProductsList = [];

  Future<void> getAllSubCategoriesProducts({
    required int subCategoryId,
  }) async {
    emit(GetAllSubCategoriesProductsLoading());
    final result = await allSubCategoriesProductsRepos
        .getAllSubCategoriesProductsData(subCategoryId: subCategoryId);
    return result.fold((failure) {
      debugPrint(
        'AllSubCategoriesProductsCubit getAllSubCategoriesProducts failed: ${failure.errMessage}',
      );
      emit(GetAllSubCategoriesProductsError(failure.errMessage));
    }, (data) {
      allSubCategoriesProductsModel = data;
      // Replace (not append) so a refresh never duplicates items.
      allSubCategoriesProductsList = [...?data.data?.products];
      emit(GetAllSubCategoriesProductsSuccess(data));
    });
  }
}
