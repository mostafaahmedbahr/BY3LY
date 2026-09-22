import 'package:bloc/bloc.dart';

import '../../data/models/sell_all_best_view_model.dart';
import '../../data/repos/sell_all_best_view_repo.dart';
import 'sell_all_best_view_states.dart';



class SellAllBestViewCubit extends Cubit<SellAllBestViewStates> {
  SellAllBestViewCubit(this.sellAllBestViewRepo) : super(SellAllBestViewInitState());

  SellAllBestViewRepo? sellAllBestViewRepo;
  SellAllBestViewModel? sellAllBestViewModel;


  Future<void> getSellAllBestView() async {
    emit(GetAllBestViewProductsLoadingState());
    var result = await sellAllBestViewRepo!.getAllBestViewProducts();
    return result.fold((failure) {
      emit(GetAllBestViewProductsErrorState(failure.errMessage));
    }, (data) {
      sellAllBestViewModel = data;
      emit(GetAllBestViewProductsSuccessState(data));
    });
  }


}
