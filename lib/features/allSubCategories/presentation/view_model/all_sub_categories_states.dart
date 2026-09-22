
import '../../data/models/all_sub_categories_model.dart';

abstract class AllSubCategoriesStates{}

class AllSubCategoriesInitState extends AllSubCategoriesStates {}

class GetAllSubCategoriesLoading extends AllSubCategoriesStates {}

class GetAllSubCategoriesSuccess extends AllSubCategoriesStates {
  final AllSubCategoriesModel allSubCategoriesModel;
  GetAllSubCategoriesSuccess(this.allSubCategoriesModel);
}

class GetAllSubCategoriesError extends AllSubCategoriesStates {
  final String message;
  GetAllSubCategoriesError(this.message);
}
