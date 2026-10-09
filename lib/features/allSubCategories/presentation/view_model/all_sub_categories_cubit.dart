  import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/all_sub_categories_model.dart';
import '../../data/repos/all_sub_categories_repos.dart';
import 'all_sub_categories_states.dart';


class AllSubCategoriesCubit extends Cubit<AllSubCategoriesStates> {
  AllSubCategoriesCubit(this.allSubCategoriesRepos) : super(AllSubCategoriesInitState());
  static AllSubCategoriesCubit get(context) => BlocProvider.of(context);

  AllSubCategoriesRepos? allSubCategoriesRepos;
  AllSubCategoriesModel? allSubCategoriesModel;

  List<SubCategories> allSubCategoriesList=[];

  /// Session-wide per-category cache: sub-categories are fetched once
  /// per category instead of on every screen open.
  static final Map<int, AllSubCategoriesModel> _cache = {};

  /// In-flight requests shared by all instances (one per category).
  static final Map<int,
      Future<Either<Failure, AllSubCategoriesModel>>> _inFlight = {};

  /// Cached sub-categories for [categoryId], if already fetched.
  static AllSubCategoriesModel? cachedFor(int categoryId) =>
      _cache[categoryId];

  Future<void> getAllSubCategories({
    required int categoryId,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _cache[categoryId];
      if (cached?.data?.subCategories != null) {
        allSubCategoriesModel = cached;
        allSubCategoriesList = [...cached!.data!.subCategories!];
        emit(GetAllSubCategoriesSuccess(cached!));
        return;
      }
    } else {
      _cache.remove(categoryId);
    }
    emit(GetAllSubCategoriesLoading());
    _inFlight[categoryId] ??=
        allSubCategoriesRepos!.getAllSubCategoriesData(
            categoryId: categoryId);
    final result = await _inFlight[categoryId]!;
    _inFlight.remove(categoryId);
    return result.fold((failure) {
      emit(GetAllSubCategoriesError(failure.errMessage));
    }, (data) {
      allSubCategoriesModel = data;
      _cache[categoryId] = data;
      allSubCategoriesList = [...?data.data?.subCategories];
      emit(GetAllSubCategoriesSuccess(data));
    });
  }
}
