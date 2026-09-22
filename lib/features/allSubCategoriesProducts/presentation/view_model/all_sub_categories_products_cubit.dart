import 'package:bloc/bloc.dart';

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
      emit(GetAllSubCategoriesProductsError(failure.errMessage));
    }, (data) {
      allSubCategoriesProductsModel = data;
      allSubCategoriesProductsList = allSubCategoriesProductsList + allSubCategoriesProductsModel!.data!.products!;
      emit(GetAllSubCategoriesProductsSuccess(data));
    });
  }
}
