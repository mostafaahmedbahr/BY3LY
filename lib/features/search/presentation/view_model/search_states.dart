import 'package:by3ly/features/search/data/models/category_model.dart';

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



class GetAllProductsForSearchLoading extends SearchStates {}

class GetAllProductsForSearchSuccess extends SearchStates {
  final AllProductsSearchModel allProductsSearchModel;
  GetAllProductsForSearchSuccess(this.allProductsSearchModel);
}

class GetAllProductsForSearchError extends SearchStates {
  final String message;
  GetAllProductsForSearchError(this.message);
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