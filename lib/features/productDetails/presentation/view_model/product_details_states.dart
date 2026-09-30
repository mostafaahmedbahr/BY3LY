
import 'package:by3ly/features/productDetails/data/models/add_product_to_compare_model.dart';
import 'package:by3ly/features/productDetails/data/models/product_details_model.dart';

abstract class ProductDetailsStates{}

class ProductDetailsInitState extends ProductDetailsStates{}

class ProductDetailsToggleBetweenImageState extends ProductDetailsStates {
  @override
  String toString() => 'ProductDetailsToggleBetweenImageState';
}

class GetProductDetailsDataLoadingState extends ProductDetailsStates {
  @override
  String toString() => 'GetProductDetailsDataLoadingState';
}
class GetProductDetailsDataSuccessState extends ProductDetailsStates{
  final ProductDetailsModel productDetailsModel;
  GetProductDetailsDataSuccessState(this.productDetailsModel);

  @override
  String toString() =>
      'GetProductDetailsDataSuccessState(status: ${productDetailsModel.status})';
}
class GetProductDetailsDataErrorState extends ProductDetailsStates{
  final String error;
  GetProductDetailsDataErrorState(this.error);

  @override
  String toString() => 'GetProductDetailsDataErrorState(error: $error)';
}

class AddProductToCompareLoadingState extends ProductDetailsStates {
  @override
  String toString() => 'AddProductToCompareLoadingState';
}
class AddProductToCompareSuccessState extends ProductDetailsStates{
  final AddProductToCompareModel addProductToCompareModel;
  AddProductToCompareSuccessState(this.addProductToCompareModel);

  @override
  String toString() => 'AddProductToCompareSuccessState';
}
class AddProductToCompareErrorState extends ProductDetailsStates{
  final String error;
  AddProductToCompareErrorState(this.error);

  @override
  String toString() => 'AddProductToCompareErrorState(error: $error)';
}