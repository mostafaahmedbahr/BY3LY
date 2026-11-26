import 'package:by3ly/features/productSeller/data/models/product_seller_model.dart';

abstract class ProductSellerStates {}

class ProductSellerInitState extends ProductSellerStates {
  @override
  String toString() => 'ProductSellerInitState';
}

class GetProductSellerDataLoadingState extends ProductSellerStates {}

class GetProductSellerDataSuccessState extends ProductSellerStates {
  final ProductSellerModel productSellerModel;
  GetProductSellerDataSuccessState(this.productSellerModel);
}

class GetProductSellerDataErrorState extends ProductSellerStates {
  final String error;
  GetProductSellerDataErrorState(this.error);
}

class SellerDataIndexState extends ProductSellerStates {}

/// Silent background state for "load more" — the seller header/tabs stay put.
class GetProductSellerDataPaginatingState extends ProductSellerStates {}

class GetProductSellerDataPaginationErrorState extends ProductSellerStates {
  final String error;
  GetProductSellerDataPaginationErrorState(this.error);
}
