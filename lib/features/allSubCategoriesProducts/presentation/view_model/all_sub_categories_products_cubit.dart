import 'package:by3ly/core/extensions/log.dart';
import 'package:by3ly/features/allSubCategoriesProducts/presentation/views/all_sub_categories_products_widgets/products_filter.dart';
import 'package:by3ly/features/allSubCategoriesProducts/data/repos/all_sub_categories_products_repos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/all_sub_categories_products_model.dart';
import 'all_sub_categories_products_states.dart';

class AllSubCategoriesProductsCubit
    extends Cubit<AllSubCategoriesProductsStates> {
  AllSubCategoriesProductsCubit(this.allSubCategoriesProductsRepos)
    : super(AllSubCategoriesProductsInitState());

  static AllSubCategoriesProductsCubit get(BuildContext context) =>
      BlocProvider.of<AllSubCategoriesProductsCubit>(context);

  final AllSubCategoriesProductsRepos allSubCategoriesProductsRepos;
  AllSubCategoriesProductsModel? allSubCategoriesProductsModel;

  List<Products> allSubCategoriesProductsList = [];

  /// Page size used for the API and for the local fallback (when the endpoint
  /// does not report pagination info).
  static const int productsPerPage = 10;

  int subCategoryId = 0;
  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool get hasMore => currentPage < lastPage;

  /// Server-side filter (same sheet/keys as the Search screen).
  ProductsFilter productsFilter = const ProductsFilter.empty();

  void applyFilter(ProductsFilter filter) {
    productsFilter = filter;
    emit(SubCategoryProductsFilterChanged());
    // Refetch page 1 with the new query params.
    getAllSubCategoriesProducts(loadMore: false);
  }

  void clearFilter() {
    productsFilter = const ProductsFilter.empty();
    emit(SubCategoryProductsFilterChanged());
    getAllSubCategoriesProducts(loadMore: false);
  }

  /// Convenience for the scroll listener — reuses the last sub-category id.
  Future<void> loadMore() =>
      getAllSubCategoriesProducts(loadMore: true);

  Future<void> getAllSubCategoriesProducts({
    int? subCategoryId,
    bool loadMore = false,
  }) async {
    if (subCategoryId != null) this.subCategoryId = subCategoryId;
    final id = this.subCategoryId;

    if (loadMore) {
      if (isLoadingMore || !hasMore) return;
      isLoadingMore = true;
      emit(GetAllSubCategoriesProductsPaginating());
    } else {
      currentPage = 1;
      lastPage = 1;
      allSubCategoriesProductsList = [];
      emit(GetAllSubCategoriesProductsLoading());
    }

    final page = loadMore ? currentPage + 1 : 1;
    final result = await allSubCategoriesProductsRepos
        .getAllSubCategoriesProductsData(
          subCategoryId: id,
          page: page,
          perPage: productsPerPage,
          filter: productsFilter,
        );
    return result.fold(
      (failure) {
        logWarning(
          'AllSubCategoriesProductsCubit getAllSubCategoriesProducts failed: '
          '${failure.errMessage}',
        );
        isLoadingMore = false;
        if (loadMore) {
          emit(GetAllSubCategoriesProductsPaginationError(failure.errMessage));
        } else {
          emit(GetAllSubCategoriesProductsError(failure.errMessage));
        }
      },
      (data) {
        isLoadingMore = false;
        allSubCategoriesProductsModel = data;
        if (data.status != true) {
          final msg = data.message ?? 'Something went wrong';
          if (loadMore) {
            emit(GetAllSubCategoriesProductsPaginationError(msg));
          } else {
            emit(GetAllSubCategoriesProductsError(msg));
          }
          return;
        }

        final rawProducts = data.data?.products ?? [];
        final pagination = data.data?.pagination;
        late final List<Products> pageProducts;
        if (pagination != null) {
          currentPage = pagination.currentPage ?? page;
          lastPage =
              pagination.resolvedLastPage ??
              (pagination.total != null && (pagination.perPage ?? 0) > 0
                  ? (pagination.total! / pagination.perPage!).ceil()
                  : page);
          if (lastPage < 1) lastPage = 1;
          pageProducts = rawProducts;
        } else {
          // Endpoint ignored `page`: paginate the returned list locally.
          currentPage = page;
          lastPage = (rawProducts.length / productsPerPage).ceil();
          if (lastPage < 1) lastPage = 1;
          final start = (page - 1) * productsPerPage;
          pageProducts = rawProducts.skip(start).take(productsPerPage).toList();
        }

        if (loadMore) {
          allSubCategoriesProductsList = [
            ...allSubCategoriesProductsList,
            ...pageProducts,
          ];
        } else {
          allSubCategoriesProductsList = [...pageProducts];
        }
        logSuccess('page=$page/$lastPage products=${allSubCategoriesProductsList.length}');
        emit(GetAllSubCategoriesProductsSuccess(data));
      },
    );
  }
}
