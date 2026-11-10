import 'package:by3ly/features/productDetails/data/models/add_product_to_compare_model.dart';
import 'package:by3ly/features/productDetails/data/models/pause_resume_ad_model.dart'
    show PauseAdResumeAdModel;
import 'package:by3ly/features/productDetails/data/models/product_details_model.dart';
import 'package:by3ly/features/productDetails/data/repos/product_details_repo.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsStates> {
  ProductDetailsCubit(this.productDetailsRepo)
    : super(ProductDetailsInitState());

  static ProductDetailsCubit get(BuildContext context) =>
      BlocProvider.of<ProductDetailsCubit>(context);

  int imageIndex = 0;
  void toggleBetweenImages(int index) {
    imageIndex = index;
    emit(ProductDetailsToggleBetweenImageState());
  }

  final ProductDetailsRepo productDetailsRepo;
  ProductDetailsModel? productDetailsModel;

  Future<void> getProductDetailsData({
    required int productId,
    required String type,
  }) async {
    emit(GetProductDetailsDataLoadingState());
    var result = await productDetailsRepo.getProductDetailsData(
      productId: productId,
      type: type,
    );
    return result.fold(
      (failure) {
        debugPrint(
          'ProductDetailsCubit getProductDetailsData failed: ${failure.errMessage}',
        );
        emit(GetProductDetailsDataErrorState(failure.errMessage));
      },
      (data) {
        if (data.status == true) {
          productDetailsModel = data;
          emit(GetProductDetailsDataSuccessState(data));
        } else {
          emit(GetProductDetailsDataErrorState(data.message.toString()));
        }
      },
    );
  }

  AddProductToCompareModel? addProductToCompareModel;
  Future<void> addProductToCompare({required int productId}) async {
    emit(AddProductToCompareLoadingState());
    var result = await productDetailsRepo.addProductToCompare(
      productId: productId,
    );
    return result.fold(
      (failure) {
        debugPrint(
          'ProductDetailsCubit addProductToCompare failed: ${failure.errMessage}',
        );
        emit(AddProductToCompareErrorState(failure.errMessage));
      },
      (data) {
        if (data.status == true) {
          addProductToCompareModel = data;
          emit(AddProductToCompareSuccessState(data));
        } else {
          emit(AddProductToCompareErrorState(data.message.toString()));
        }
      },
    );
  }

  Future<void> rateProduct({
    required int productId,
    required int rate,
    required String commenet,
    required String type,
  }) async {
    emit(RateProductLoadingState());
    var result = await productDetailsRepo.rateProduct(
      productId: productId,
      rate: rate,
      commenet: commenet,
    );
    return result.fold(
      (failure) {
        debugPrint(
          'ProductDetailsCubit rateProduct failed: ${failure.errMessage}',
        );
        emit(RateProductErrorState(failure.errMessage));
      },
      (data) {
        if (data.status == true) {
          emit(RateProductSuccessState(data.message));
          // Refresh details so the new rate/review appears at once.
          getProductDetailsData(productId: productId, type: type);
        } else {
          emit(RateProductErrorState(data.message ?? 'Something went wrong'));
        }
      },
    );
  }

  PauseAdResumeAdModel? pauseAdResumeAdModel;

  Future<void> pauseAd({required int adId}) =>
      _changePauseState(adId: adId, pause: true);

  Future<void> resumeAd({required int adId}) =>
      _changePauseState(adId: adId, pause: false);

  /// Pauses or resumes the ad, then updates the loaded product locally so the
  /// details screen reflects the new state without another request.
  Future<void> _changePauseState({
    required int adId,
    required bool pause,
  }) async {
    emit(PauseResumeAdLoadingState());
    var result = pause
        ? await productDetailsRepo.pauseAd(adId: adId)
        : await productDetailsRepo.resumeAd(adId: adId);

    return result.fold(
      (failure) {
        debugPrint(
          'ProductDetailsCubit ${pause ? 'pauseAd' : 'resumeAd'} failed: '
          '${failure.errMessage}',
        );
        emit(PauseResumeAdErrorState(failure.errMessage));
      },
      (data) {
        if (data.status == true) {
          pauseAdResumeAdModel = data;
          final product = productDetailsModel?.data?.product;
          final isPaused = data.data?.isPaused;
          if (product != null && isPaused != null) {
            product.isPaused = isPaused;
          }
          emit(PauseResumeAdSuccessState(data));
        } else {
          emit(PauseResumeAdErrorState(data.message ?? 'Something went wrong'));
        }
      },
    );
  }
}
