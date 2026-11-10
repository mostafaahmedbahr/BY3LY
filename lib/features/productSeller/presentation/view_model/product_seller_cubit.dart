import 'package:by3ly/features/productSeller/presentation/view_model/product_seller_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:by3ly/features/productSeller/data/models/product_seller_model.dart';
import 'package:by3ly/features/productSeller/data/repos/product_seller_repos.dart';

class ProductSellerCubit extends Cubit<ProductSellerStates> {
  ProductSellerCubit(this.productSellerRepo)
      : super(ProductSellerInitState());

  static ProductSellerCubit get(BuildContext context) =>
      BlocProvider.of<ProductSellerCubit>(context);


  final ProductSellerRepo productSellerRepo;
  ProductSellerModel? productSellerModel;

  Future<void> getProductSellerData({
    required int sellerId,
  }) async {
    emit(GetProductSellerDataLoadingState());
    var result = await productSellerRepo.getProductSellerData(
      sellerId: sellerId,
    );
    return result.fold((failure) {
      emit(GetProductSellerDataErrorState(failure.errMessage));
    }, (data) {
      if(data.status == true){
        productSellerModel = data;
        emit(GetProductSellerDataSuccessState(data));
      }else{
        emit(GetProductSellerDataErrorState(data.message.toString()));
      }
    });
  }

  int sellerDataIndex = 1 ;
  void changeSellerDataIndex(int index) {
    sellerDataIndex = index;

    emit(SellerDataIndexState());
  }


}