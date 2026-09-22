import 'package:by3ly/features/productSeller/presentation/view_model/product_seller_states.dart';

import '../../../../main_importants.dart';
import '../../data/models/product_seller_model.dart';
import '../../data/repos/product_seller_repos.dart';

class ProductSellerCubit extends Cubit<ProductSellerStates> {
  ProductSellerCubit(this.productSellerRepo)
      : super(ProductSellerInitState());

  static ProductSellerCubit get(context) => BlocProvider.of(context);


  ProductSellerRepo? productSellerRepo;
  ProductSellerModel? productSellerModel;

  Future<void> getProductSellerData({
    required int sellerId,
  }) async {
    emit(GetProductSellerDataLoadingState());
    var result = await productSellerRepo!.getProductSellerData(
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
  changeSellerDataIndex(index)
  {
    sellerDataIndex = index;

    emit(SellerDataIndexState());
  }


}