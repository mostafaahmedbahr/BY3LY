
import '../../data/models/add_product_to_compare_model.dart';
import '../../data/models/product_details_model.dart';

abstract class ProductDetailsStates{}

class ProductDetailsInitState extends ProductDetailsStates{}

class ProductDetailsToggleBetweenImageState extends ProductDetailsStates{}

class GetProductDetailsDataLoadingState extends ProductDetailsStates{}
class GetProductDetailsDataSuccessState extends ProductDetailsStates{
  final ProductDetailsModel productDetailsModel;
  GetProductDetailsDataSuccessState(this.productDetailsModel);
}
class GetProductDetailsDataErrorState extends ProductDetailsStates{
  final String error;
  GetProductDetailsDataErrorState(this.error);
}

class AddProductToCompareLoadingState extends ProductDetailsStates{}
class AddProductToCompareSuccessState extends ProductDetailsStates{
  final AddProductToCompareModel addProductToCompareModel;
  AddProductToCompareSuccessState(this.addProductToCompareModel);
}
class AddProductToCompareErrorState extends ProductDetailsStates{
  final String error;
  AddProductToCompareErrorState(this.error);
}