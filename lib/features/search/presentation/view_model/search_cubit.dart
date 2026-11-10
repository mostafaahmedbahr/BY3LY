
import 'package:by3ly/features/allSubCategoriesProducts/presentation/views/all_sub_categories_products_widgets/products_filter.dart';
import 'package:by3ly/features/search/presentation/view_model/search_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/all_products_search_model.dart';
import '../../data/repos/search_repos.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit(this.searchRepos) : super(SearchInitState());

  static SearchCubit get(BuildContext context) =>
      BlocProvider.of<SearchCubit>(context);


  final SearchRepos searchRepos;
  AllProductsSearchModel? allProductsSearchModel;

  List<Products> allProductsForSearchList = [];

  /// Server-side pagination bookkeeping (Laravel-style).
  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool get hasMore => currentPage < lastPage;

  /// Local filter applied on top of the loaded pages
  /// (same sheet used in the sub-category products screen).
  ProductsFilter searchFilter = const ProductsFilter.empty();

  void applySearchFilter(ProductsFilter filter) {
    searchFilter = filter;
    emit(SearchFilterChanged());
    // Server-side filter: refetch page 1 with the new query params.
    getAllProductsForSearch();
  }

  void clearSearchFilter() {
    searchFilter = const ProductsFilter.empty();
    emit(SearchFilterChanged());
    getAllProductsForSearch();
  }

  Future<void> getAllProductsForSearch({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return;
      isLoadingMore = true;
      emit(GetAllProductsForSearchPaginating());
    } else {
      currentPage = 1;
      lastPage = 1;
      emit(GetAllProductsForSearchLoading());
    }
    final int page = loadMore ? currentPage + 1 : 1;
    var result = await searchRepos.getAllProductsForSearch(
      page: page,
      filter: searchFilter,
    );
    return result.fold((failure) {
      debugPrint('SearchCubit getAllProductsForSearch failed: ${failure.errMessage}');
      isLoadingMore = false;
      if (loadMore) {
        emit(GetAllProductsForSearchPaginationError(failure.errMessage));
      } else {
        emit(GetAllProductsForSearchError(failure.errMessage));
      }
    }, (data) {
     if(data.status==true){
       allProductsSearchModel = data;
       final newProducts = data.data?.products ?? [];
       final pagination = data.data?.pagination;
       if (pagination != null) {
         currentPage = pagination.currentPage ?? page;
         lastPage = pagination.lastPage ?? page;
       } else {
         // Backend sent no pagination info: treat as a single page.
         currentPage = page;
         lastPage = page;
       }
       if (loadMore) {
         allProductsForSearchList = [...allProductsForSearchList, ...newProducts];
       } else {
         allProductsForSearchList = [...newProducts];
       }
       isLoadingMore = false;
       emit(GetAllProductsForSearchSuccess(data));
     }else{
       isLoadingMore = false;
       final msg = data.message ?? 'Something went wrong';
       if (loadMore) {
         emit(GetAllProductsForSearchPaginationError(msg));
       } else {
         emit(GetAllProductsForSearchError(msg));
       }
     }
    });
  }

}