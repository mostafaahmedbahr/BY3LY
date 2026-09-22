  import 'package:by3ly/features/productDetails/presentation/view_model/product_details_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/add_product_to_compare_model.dart';
import '../../data/models/product_details_model.dart';
import '../../data/repos/product_details_repo.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsStates> {
  ProductDetailsCubit(this.productDetailsRepo) : super(ProductDetailsInitState());

  static ProductDetailsCubit get(context) => BlocProvider.of(context);

  int imageIndex = 0;
  toggleBetweenImages(index)
  {
    imageIndex = index;
    emit(ProductDetailsToggleBetweenImageState());
  }


  List<String> images = [
    "https://tse1.mm.bing.net/th?id=OIP.vEVEgHS_-4yah18DgkuLBQHaEK&pid=Api&P=0&h=220",
    "https://img.freepik.com/premium-photo/blue-bmw-m5-driving-down-road_866324-3.jpg?w=740",
    "https://img.freepik.com/free-psd/white-car-isolated_176382-1481.jpg?w=900&t=st=1716739202~exp=1716739802~hmac=272dfdf514d49d998c3706b2607abd4864ee4c385d774d4d74b57cd5c1170df8",
    "https://img.freepik.com/free-photo/yellow-car-gas-station_23-2150697544.jpg?w=900&t=st=1716739218~exp=1716739818~hmac=df7dc7e9ad111896e8ff96db1d295e78c73f3c5aecfd918f4007d27ae5d2fb81",
  ];


  List<String> safetyTipsList = [
    LocaleKeys.inspectProductThoroughlyBeforeBuying .tr(),
    LocaleKeys.takeSomeoneWithYou .tr(),
    LocaleKeys.dontPayUntilEnsuringSafety .tr(),
    LocaleKeys.meetSellerInPublicPlace .tr(),
  ];



  ProductDetailsRepo? productDetailsRepo;
  ProductDetailsModel? productDetailsModel;

  Future<void> getProductDetailsData({
    required int productId, required String type
  }) async {
    emit(GetProductDetailsDataLoadingState());
    var result = await productDetailsRepo!.getProductDetailsData(
      productId: productId,
      type: type,
    );
    return result.fold((failure) {
      emit(GetProductDetailsDataErrorState(failure.errMessage));
    }, (data) {
      if(data.status == true){
        productDetailsModel = data;
        emit(GetProductDetailsDataSuccessState(data));
      }else{
        emit(GetProductDetailsDataErrorState(data.message.toString()));
      }
    });
  }


  AddProductToCompareModel? addProductToCompareModel;
  Future<void> addProductToCompare({
    required int productId,
  }) async {
    emit(AddProductToCompareLoadingState());
    var result = await productDetailsRepo!.addProductToCompare(
      productId: productId,
    );
    return result.fold((failure) {
      emit(AddProductToCompareErrorState(failure.errMessage));
    }, (data) {
      if(data.status == true){
        addProductToCompareModel = data;
        emit(AddProductToCompareSuccessState(data));
      }else{
        emit(AddProductToCompareErrorState(data.message.toString()));
      }
    });
  }



}