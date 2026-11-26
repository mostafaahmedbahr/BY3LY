import 'package:by3ly/features/productSeller/presentation/view_model/product_seller_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:by3ly/features/productSeller/data/models/product_seller_model.dart';
import 'package:by3ly/features/productSeller/data/repos/product_seller_repos.dart';

class ProductSellerCubit extends Cubit<ProductSellerStates> {
  ProductSellerCubit(this.productSellerRepo) : super(ProductSellerInitState());

  static ProductSellerCubit get(BuildContext context) =>
      BlocProvider.of<ProductSellerCubit>(context);

  final ProductSellerRepo productSellerRepo;
  ProductSellerModel? productSellerModel;

  /// The API returns 10 products per page (100 for the demo seller).
  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool get hasMore => currentPage < lastPage;

  Future<void> getProductSellerData({
    required int sellerId,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return;
      isLoadingMore = true;
      emit(GetProductSellerDataPaginatingState());
    } else {
      currentPage = 1;
      lastPage = 1;
      emit(GetProductSellerDataLoadingState());
    }

    final page = loadMore ? currentPage + 1 : 1;
    var result = await productSellerRepo.getProductSellerData(
      sellerId: sellerId,
      page: page,
    );
    return result.fold(
      (failure) {
        isLoadingMore = false;
        if (loadMore) {
          emit(GetProductSellerDataPaginationErrorState(failure.errMessage));
        } else {
          emit(GetProductSellerDataErrorState(failure.errMessage));
        }
      },
      (data) {
        isLoadingMore = false;
        if (data.status != true) {
          final message = data.message.toString();
          if (loadMore) {
            emit(GetProductSellerDataPaginationErrorState(message));
          } else {
            emit(GetProductSellerDataErrorState(message));
          }
          return;
        }

        final pagination = data.data?.pagination;
        currentPage = pagination?.currentPage ?? page;
        lastPage = pagination?.totalPages ?? currentPage;

        if (loadMore && productSellerModel?.data != null) {
          final cached = productSellerModel!;
          final target = cached.data!;
          final existing = target.products ?? <Products>[];
          final seen = existing.map((p) => p.id).toSet();
          final fresh = (data.data?.products ?? <Products>[])
              .where((p) => !seen.contains(p.id))
              .toList();
          target
            ..products = [...existing, ...fresh]
            ..pagination = pagination ?? target.pagination;
          emit(GetProductSellerDataSuccessState(cached));
        } else {
          productSellerModel = data;
          emit(GetProductSellerDataSuccessState(data));
        }
      },
    );
  }

  int sellerDataIndex = 1;
  void changeSellerDataIndex(int index) {
    sellerDataIndex = index;

    emit(SellerDataIndexState());
  }
}
