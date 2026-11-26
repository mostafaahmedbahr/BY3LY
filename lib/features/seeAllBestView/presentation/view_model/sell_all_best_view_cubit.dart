import 'package:by3ly/core/extensions/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:by3ly/features/seeAllBestView/data/models/sell_all_best_view_model.dart';
import 'package:by3ly/features/seeAllBestView/data/repos/sell_all_best_view_repo.dart';
import 'sell_all_best_view_states.dart';

class SellAllBestViewCubit extends Cubit<SellAllBestViewStates> {
  SellAllBestViewCubit(this.sellAllBestViewRepo)
    : super(SellAllBestViewInitState());

  static SellAllBestViewCubit get(BuildContext context) =>
      BlocProvider.of<SellAllBestViewCubit>(context);

  final SellAllBestViewRepo sellAllBestViewRepo;
  SellAllBestViewModel? sellAllBestViewModel;

  /// Server pagination — the API sends 10 per page (121 items total).
  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool get hasMore => currentPage < lastPage;

  Future<void> getSellAllBestView({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return;
      isLoadingMore = true;
      emit(GetAllBestViewProductsPaginatingState());
    } else {
      currentPage = 1;
      lastPage = 1;
      emit(GetAllBestViewProductsLoadingState());
    }

    final page = loadMore ? currentPage + 1 : 1;
    var result = await sellAllBestViewRepo.getAllBestViewProducts(page: page);
    return result.fold(
      (failure) {
        logWarning('SellAllBestViewCubit failed: ${failure.errMessage}');
        isLoadingMore = false;
        if (loadMore) {
          emit(GetAllBestViewProductsPaginationErrorState(failure.errMessage));
        } else {
          emit(GetAllBestViewProductsErrorState(failure.errMessage));
        }
      },
      (data) {
        isLoadingMore = false;
        if (data.status != true) {
          final message = data.message ?? 'Something went wrong';
          if (loadMore) {
            emit(GetAllBestViewProductsPaginationErrorState(message));
          } else {
            emit(GetAllBestViewProductsErrorState(message));
          }
          return;
        }

        final pagination = data.data?.pagination;
        currentPage = pagination?.currentPage ?? page;
        lastPage = pagination?.totalPages ?? currentPage;

        if (loadMore && sellAllBestViewModel != null) {
          // Append instead of replacing so earlier pages stay on screen.
          final cached = sellAllBestViewModel!;
          final target = cached.data ?? Data();
          cached.data = target;
          final existing = target.products ?? <Products>[];
          final seen = existing.map((p) => p.id).toSet();
          final fresh = (data.data?.products ?? <Products>[])
              .where((p) => !seen.contains(p.id))
              .toList();
          target
            ..products = [...existing, ...fresh]
            ..pagination = pagination ?? target.pagination;
          emit(GetAllBestViewProductsSuccessState(cached));
        } else {
          sellAllBestViewModel = data;
          emit(GetAllBestViewProductsSuccessState(data));
        }
      },
    );
  }
}
