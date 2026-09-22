    import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/add_remove_product_to_fav_model.dart';
import '../../data/models/home_model.dart';
import '../../data/repos/home_repo.dart';
import 'home_states.dart';


class HomeCubit extends Cubit<HomeStates> {
    HomeCubit(this.homeRepo) : super(HomeInitState());

    static HomeCubit get(context) => BlocProvider.of(context);

  HomeRepo? homeRepo;
  HomeModel? homeModel;


  Future<void> getHome() async {
    emit(GetHomeDataLoading());
    var result = await homeRepo!.getHomeData();
    return result.fold((failure) {
      emit(GetHomeDataError(failure.errMessage));
    }, (data) {
      homeModel = data;
       emit(GetHomeDataSuccess(data));
    });
  }



  AddRemoveProductToFavModel? addRemoveProductToFavModel;


  Future<void> addRemoveProductToFavMethod({required int productId}) async {
    emit(AddRemoveProductToFavLoadingState());
    var result = await homeRepo!.addRemoveProductToFav(productId: productId);
    return result.fold((failure) {
      emit(AddRemoveProductToFavErrorState(failure.errMessage));
    }, (data) {
      if(data.status==true){
        addRemoveProductToFavModel = data;
        emit(AddRemoveProductToFavSuccessState(data));
      }else{
        emit(AddRemoveProductToFavErrorState(data.message.toString()));
      }

    });
  }


}
