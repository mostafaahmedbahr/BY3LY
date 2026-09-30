
import '../../data/models/all_sub_categories_products_model.dart';

abstract class AllSubCategoriesProductsStates{}

class AllSubCategoriesProductsInitState extends AllSubCategoriesProductsStates {}

class GetAllSubCategoriesProductsLoading extends AllSubCategoriesProductsStates {
  @override
  String toString() => 'GetAllSubCategoriesProductsLoading';
}

class GetAllSubCategoriesProductsSuccess extends AllSubCategoriesProductsStates {
  final AllSubCategoriesProductsModel allSubCategoriesProductsModel;
  GetAllSubCategoriesProductsSuccess(this.allSubCategoriesProductsModel);

  @override
  String toString() =>
      'GetAllSubCategoriesProductsSuccess(status: ${allSubCategoriesProductsModel.status}, message: ${allSubCategoriesProductsModel.message})';
}

class GetAllSubCategoriesProductsError extends AllSubCategoriesProductsStates {
  final String message;
  GetAllSubCategoriesProductsError(this.message);

  @override
  String toString() => 'GetAllSubCategoriesProductsError(message: $message)';
}
