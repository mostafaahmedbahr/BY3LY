 import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/all_sub_categories_model.dart';
import '../../data/repos/all_sub_categories_repos.dart';
import 'all_sub_categories_states.dart';


class AllSubCategoriesCubit extends Cubit<AllSubCategoriesStates> {
  AllSubCategoriesCubit(this.allSubCategoriesRepos) : super(AllSubCategoriesInitState());
  static AllSubCategoriesCubit get(context) => BlocProvider.of(context);

  AllSubCategoriesRepos? allSubCategoriesRepos;
  AllSubCategoriesModel? allSubCategoriesModel;

  List<SubCategories> allSubCategoriesList=[];
  Future<void> getAllSubCategories({
    required int categoryId,
}) async {
    emit(GetAllSubCategoriesLoading());
    var result = await allSubCategoriesRepos!.getAllSubCategoriesData(
        categoryId: categoryId);
    return result.fold((failure) {
      emit(GetAllSubCategoriesError(failure.errMessage));
    }, (data) {
      allSubCategoriesModel = data;
      allSubCategoriesList = allSubCategoriesList + allSubCategoriesModel!.data!.subCategories!;
      emit(GetAllSubCategoriesSuccess(data));
    });
  }
}
