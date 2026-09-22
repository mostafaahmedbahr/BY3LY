 import 'package:by3ly/core/general_models/general_model.dart';
   import 'package:by3ly/features/fav/data/models/fav_model.dart';

import '../../../../main_importants.dart';
import '../../data/repos/fav_repos.dart';
import 'fav_states.dart';


class FavCubit extends Cubit<FavStates> {
  FavCubit(this.favRepos) : super(FavInitState());

  static FavCubit get(context) => BlocProvider.of(context);


  FavRepos? favRepos;
  FavDataModel? favDataModel;

  Future<void> getFavData() async {
    emit(GetFavDataLoading());
    var result = await favRepos!.getFavData();
    return result.fold((failure) {
      emit(GetFavDataError(failure.errMessage));
    }, (data) {
      if(data.status==true){
        favDataModel = data;
        emit(GetFavDataSuccess(data));
      }
      else{
        emit(GetFavDataError(data.message.toString()));
      }
    });
  }

  GeneralModel? removeProductFromFavModel;
  Future<void> removeProductFromFav({
    required int productId,
}) async {
    emit(RemoveProductFromFavLoading());
    var result = await favRepos!.removeProductFromFav(productId: productId);
    return result.fold((failure) {
      emit(RemoveProductFromFavError(failure.errMessage));
    }, (data) {
      if(data.status==true){
        removeProductFromFavModel = data;
        emit(RemoveProductFromFavSuccess(data));
      }
      else{
        emit(RemoveProductFromFavError(data.message.toString()));
      }
    });
  }
}
