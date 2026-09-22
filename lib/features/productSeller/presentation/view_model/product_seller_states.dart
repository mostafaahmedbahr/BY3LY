

import '../../data/models/product_seller_model.dart';

abstract class ProductSellerStates{}

class ProductSellerInitState extends ProductSellerStates{}

class GetProductSellerDataLoadingState extends ProductSellerStates{}
class GetProductSellerDataSuccessState extends ProductSellerStates{
  final ProductSellerModel productSellerModel;
  GetProductSellerDataSuccessState(this.productSellerModel);
}
class GetProductSellerDataErrorState extends ProductSellerStates{
  final String error;
  GetProductSellerDataErrorState(this.error);
}

class SellerDataIndexState extends ProductSellerStates{}