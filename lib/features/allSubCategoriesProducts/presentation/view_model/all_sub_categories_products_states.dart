import '../../data/models/all_sub_categories_products_model.dart';

abstract class AllSubCategoriesProductsStates {}

class AllSubCategoriesProductsInitState
    extends AllSubCategoriesProductsStates {}

class GetAllSubCategoriesProductsLoading
    extends AllSubCategoriesProductsStates {
  @override
  String toString() => 'GetAllSubCategoriesProductsLoading';
}

class GetAllSubCategoriesProductsSuccess
    extends AllSubCategoriesProductsStates {
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

/// Next page is loading; already loaded products stay visible.
class GetAllSubCategoriesProductsPaginating
    extends AllSubCategoriesProductsStates {
  @override
  String toString() => 'GetAllSubCategoriesProductsPaginating';
}

/// Next page failed; loaded products stay visible and the footer shows retry.
class GetAllSubCategoriesProductsPaginationError
    extends AllSubCategoriesProductsStates {
  final String message;
  GetAllSubCategoriesProductsPaginationError(this.message);

  @override
  String toString() =>
      'GetAllSubCategoriesProductsPaginationError(message: $message)';
}

/// Filter sheet applied/cleared — lets the list rebuild its chips.
class SubCategoryProductsFilterChanged
    extends AllSubCategoriesProductsStates {
  @override
  String toString() => 'SubCategoryProductsFilterChanged';
}
