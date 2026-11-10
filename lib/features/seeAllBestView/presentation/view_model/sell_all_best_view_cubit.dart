import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:by3ly/features/seeAllBestView/data/models/sell_all_best_view_model.dart';
import 'package:by3ly/features/seeAllBestView/data/repos/sell_all_best_view_repo.dart';
import 'sell_all_best_view_states.dart';



class SellAllBestViewCubit extends Cubit<SellAllBestViewStates> {
  SellAllBestViewCubit(this.sellAllBestViewRepo) : super(SellAllBestViewInitState());

  static SellAllBestViewCubit get(BuildContext context) =>
      BlocProvider.of<SellAllBestViewCubit>(context);

  final SellAllBestViewRepo sellAllBestViewRepo;
  SellAllBestViewModel? sellAllBestViewModel;


  Future<void> getSellAllBestView() async {
    emit(GetAllBestViewProductsLoadingState());
    var result = await sellAllBestViewRepo.getAllBestViewProducts();
    return result.fold((failure) {
      debugPrint('SellAllBestViewCubit failed: ${failure.errMessage}');
      emit(GetAllBestViewProductsErrorState(failure.errMessage));
    }, (data) {
      if (data.status == true) {
        sellAllBestViewModel = data;
        emit(GetAllBestViewProductsSuccessState(data));
      } else {
        emit(GetAllBestViewProductsErrorState(
            data.message ?? 'Something went wrong'));
      }
    });
  }


}
