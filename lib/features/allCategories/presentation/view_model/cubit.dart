import 'package:bloc/bloc.dart';
import 'package:by3ly/features/allCategories/data/models/all_categoies_model.dart';
import 'package:by3ly/features/allCategories/data/repositories/all_categories_repo.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/states.dart';


class AllCategoriesCubit extends Cubit<AllCategoriesStates> {
  AllCategoriesCubit(this.allCategoriesRepo) : super(AllCategoriesInitState());

  AllCategoriesRepo? allCategoriesRepo;
  AllCategoriesModel? allCategoriesModel;

  List<Categories> allCategoriesList=[];

  /// Session-wide cache: categories are fetched once, later screens
  /// reuse them instead of calling the API on every open.
  static AllCategoriesModel? cachedModel;

  Future<void> getAllCategories({bool forceRefresh = false}) async {
    final cached = forceRefresh ? null : (cachedModel ?? allCategoriesModel);
    if (cached?.data?.categories?.isNotEmpty == true) {
      allCategoriesModel = cached;
      allCategoriesList = [...cached!.data!.categories!];
      emit(GetAllCategoriesSuccess(cached!));
      return;
    }
    emit(GetAllCategoriesLoading());
    var result = await allCategoriesRepo!.getAllCategories();
    return result.fold((failure) {
      emit(GetAllCategoriesError(failure.errMessage));
    }, (data) {
      allCategoriesModel = data;
      cachedModel = data;
      allCategoriesList = [...?data.data?.categories];
      emit(GetAllCategoriesSuccess(data));
    });
  }
}
