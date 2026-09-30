import 'package:by3ly/features/productDetails/data/models/product_details_model.dart'
    as details;
import 'package:by3ly/features/productDetails/data/repos/product_details_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/compare_model.dart';
import '../../data/repos/compare_repos.dart';
import 'compare_states.dart';

/// Holds up to 2 product ids picked for comparison from anywhere
/// (usually the details page) and fetches their side-by-side data.
class CompareCubit extends Cubit<CompareStates> {
  CompareCubit(this.compareRepos, [this.productDetailsRepo])
      : super(CompareInitState());

  static CompareCubit get(context) => BlocProvider.of(context);

  CompareRepos? compareRepos;
  ProductDetailsRepo? productDetailsRepo;
  CompareModel? compareModel;

  /// Max products allowed in one comparison.
  static const int maxItems = 2;

  final List<int> basketIds = [];

  bool isInBasket(int productId) => basketIds.contains(productId);

  bool get isBasketFull => basketIds.length >= maxItems;

  /// Returns true if the product ended up IN the basket.
  bool toggleBasket(int productId) {
    if (basketIds.contains(productId)) {
      basketIds.remove(productId);
      emit(CompareBasketChanged([...basketIds]));
      return false;
    }
    if (basketIds.length >= maxItems) {
      // Replace the oldest pick so the flow never dead-ends.
      basketIds.removeAt(0);
    }
    basketIds.add(productId);
    emit(CompareBasketChanged([...basketIds]));
    return true;
  }

  void removeFromBasket(int productId) {
    basketIds.remove(productId);
    // Keep compareModel: the remaining product stays visible.
    emit(CompareBasketChanged([...basketIds]));
  }

  void clearBasket() {
    basketIds.clear();
    compareModel = null;
    emit(CompareBasketChanged(const []));
  }

  Future<void> fetchComparison() async {
    if (basketIds.length < 2) return;
    emit(CompareProductsLoading());
    var result = await compareRepos!
        .compareProducts(productIds: [...basketIds]);
    return result.fold((failure) async {
      debugPrint('CompareCubit fetchComparison failed: ${failure.errMessage}');
      await _fetchDetailsFallback();
    }, (data) async {
      final products = data.data?.products ?? [];
      if (data.status == true && products.length >= 2) {
        compareModel = data;
        emit(CompareProductsSuccess(data));
      } else {
        debugPrint(
            'CompareCubit compareProducts returned ${products.length} items, using details fallback');
        await _fetchDetailsFallback();
      }
    });
  }

  /// Fallback: builds the comparison from the regular product-details
  /// endpoint so the two picked products ALWAYS display, even if the
  /// dedicated compare endpoint fails or returns an unexpected shape.
  Future<void> _fetchDetailsFallback() async {
    if (productDetailsRepo == null || basketIds.length < 2) {
      emit(CompareProductsError('Something went wrong'));
      return;
    }
    emit(CompareProductsLoading());
    try {
      final results = await Future.wait([
        productDetailsRepo!.getProductDetailsData(
            productId: basketIds[0], type: 'home'),
        productDetailsRepo!.getProductDetailsData(
            productId: basketIds[1], type: 'home'),
      ]);
      final products = <CompareProduct>[];
      for (final r in results) {
        r.fold((_) {}, (detailsModel) {
          final p = detailsModel.data?.product;
          if (p != null) products.add(_fromDetailsProduct(p));
        });
      }
      if (products.length >= 2) {
        final model = CompareModel(
          status: true,
          message: 'fallback',
          data: CompareData(products: products),
        );
        compareModel = model;
        emit(CompareProductsSuccess(model));
      } else {
        emit(CompareProductsError('Something went wrong'));
      }
    } catch (e) {
      debugPrint('CompareCubit details fallback failed: $e');
      emit(CompareProductsError(e.toString()));
    }
  }

  CompareProduct _fromDetailsProduct(details.Product p) {
    return CompareProduct(
      id: p.id,
      name: p.name,
      desc: p.desc ?? p.description,
      price: p.price?.toString() ?? p.finalPrice?.toString(),
      image: p.image,
      images: p.images?.map((e) => e.image).toList() ?? [],
      rate: p.rate?.toString(),
      reviewsCount: p.reviewsCount,
      type: p.type,
      model: p.model,
      marka: p.marka,
      location: p.location?.toString(),
      date: p.date,
      createdAt: p.createdAt,
    );
  }
}
