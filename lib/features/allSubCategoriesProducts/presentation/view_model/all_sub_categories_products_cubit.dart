import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/all_sub_categories_products_model.dart';
import '../../data/repos/all_sub_categories_products_repos.dart';
import 'all_sub_categories_products_states.dart';


class AllSubCategoriesProductsCubit extends Cubit<AllSubCategoriesProductsStates> {
  AllSubCategoriesProductsCubit(this.allSubCategoriesProductsRepos) : super(AllSubCategoriesProductsInitState());

  AllSubCategoriesProductsRepos? allSubCategoriesProductsRepos;
  AllSubCategoriesProductsModel? allSubCategoriesProductsModel;

  List<Products> allSubCategoriesProductsList=[];
  Future<void> getAllSubCategoriesProducts({
    required int subCategoryId,
}) async {
    emit(GetAllSubCategoriesProductsLoading());
    var result = await allSubCategoriesProductsRepos!.getAllSubCategoriesProductsData(subCategoryId: subCategoryId);
    return result.fold((failure) {
      debugPrint(
          'AllSubCategoriesProductsCubit getAllSubCategoriesProducts failed: ${failure.errMessage}');
      emit(GetAllSubCategoriesProductsError(failure.errMessage));
    }, (data) {
      allSubCategoriesProductsModel = data;
      final newProducts = data.data?.products;
      if (newProducts != null) {
        allSubCategoriesProductsList =
            allSubCategoriesProductsList + newProducts;
      }
      emit(GetAllSubCategoriesProductsSuccess(data));
    });
  }
}
