
import '../../data/models/all_products_search_model.dart';
abstract class SearchStates{}

class SearchInitState extends SearchStates{}

class SelectCategoryState extends SearchStates{}
class SelectSubCategoryState extends SearchStates{}

class SelectShippingOptionState extends SearchStates{}

class SelectedConditionOptionState extends SearchStates{}

class GovernoratesLoaded extends SearchStates {
  final List<String> governorates;
  final List<String> centers;
  final String? selectedGovernorate;
  final String? selectedCenter;

  GovernoratesLoaded(this.governorates, this.centers, this.selectedGovernorate, this.selectedCenter);
}



class GetAllProductsForSearchLoading extends SearchStates {
  @override
  String toString() => 'GetAllProductsForSearchLoading';
}

class GetAllProductsForSearchSuccess extends SearchStates {
  final AllProductsSearchModel allProductsSearchModel;
  GetAllProductsForSearchSuccess(this.allProductsSearchModel);

  @override
  String toString() =>
      'GetAllProductsForSearchSuccess(status: ${allProductsSearchModel.status})';
}

class GetAllProductsForSearchError extends SearchStates {
  final String message;
  GetAllProductsForSearchError(this.message);

  @override
  String toString() => 'GetAllProductsForSearchError(message: $message)';
}

/// Emitted while the next page is loading (list keeps old items).
class GetAllProductsForSearchPaginating extends SearchStates {
  @override
  String toString() => 'GetAllProductsForSearchPaginating';
}

/// Next-page request failed (list keeps old items, footer shows retry).
class GetAllProductsForSearchPaginationError extends SearchStates {
  final String message;
  GetAllProductsForSearchPaginationError(this.message);

  @override
  String toString() =>
      'GetAllProductsForSearchPaginationError(message: $message)';
}

/// Emitted when the local search filter changes.
class SearchFilterChanged extends SearchStates {
  @override
  String toString() => 'SearchFilterChanged';
}


// class CategoriesLoaded extends SearchStates {
//   final List<CategoryModel> categories;
//   final List<String> subCategories;
//   final String? selectedCategory;
//   final String? selectedSubCategory;
//
//   CategoriesLoaded(
//       this.categories,
//       this.subCategories,
//       this.selectedCategory,
//       this.selectedSubCategory,
//       );
// }