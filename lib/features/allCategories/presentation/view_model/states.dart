import 'package:by3ly/features/allCategories/data/models/all_categoies_model.dart';

abstract class AllCategoriesStates{}

class AllCategoriesInitState extends AllCategoriesStates {}

class GetAllCategoriesLoading extends AllCategoriesStates {}

class GetAllCategoriesSuccess extends AllCategoriesStates {
  final AllCategoriesModel allCategoriesModel;
  GetAllCategoriesSuccess(this.allCategoriesModel);
}

class GetAllCategoriesError extends AllCategoriesStates {
  final String message;
  GetAllCategoriesError(this.message);
}
