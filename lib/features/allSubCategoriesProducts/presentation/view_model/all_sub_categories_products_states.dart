
import '../../data/models/all_sub_categories_products_model.dart';

abstract class AllSubCategoriesProductsStates{}

class AllSubCategoriesProductsInitState extends AllSubCategoriesProductsStates {}

class GetAllSubCategoriesProductsLoading extends AllSubCategoriesProductsStates {}

class GetAllSubCategoriesProductsSuccess extends AllSubCategoriesProductsStates {
  final AllSubCategoriesProductsModel allSubCategoriesProductsModel;
  GetAllSubCategoriesProductsSuccess(this.allSubCategoriesProductsModel);
}

class GetAllSubCategoriesProductsError extends AllSubCategoriesProductsStates {
  final String message;
  GetAllSubCategoriesProductsError(this.message);
}
