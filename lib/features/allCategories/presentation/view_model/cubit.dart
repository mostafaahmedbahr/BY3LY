import 'package:bloc/bloc.dart';
import 'package:by3ly/features/allCategories/data/models/all_categoies_model.dart';
import 'package:by3ly/features/allCategories/data/repositories/all_categories_repo.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/states.dart';


class AllCategoriesCubit extends Cubit<AllCategoriesStates> {
  AllCategoriesCubit(this.allCategoriesRepo) : super(AllCategoriesInitState());

  AllCategoriesRepo? allCategoriesRepo;
  AllCategoriesModel? allCategoriesModel;

  List<Categories> allCategoriesList=[];
  Future<void> getAllCategories() async {
    emit(GetAllCategoriesLoading());
    var result = await allCategoriesRepo!.getAllCategories();
    return result.fold((failure) {
      emit(GetAllCategoriesError(failure.errMessage));
    }, (data) {
      allCategoriesModel = data;
      allCategoriesList = allCategoriesList + allCategoriesModel!.data!.categories!;
      emit(GetAllCategoriesSuccess(data));
    });
  }
}
