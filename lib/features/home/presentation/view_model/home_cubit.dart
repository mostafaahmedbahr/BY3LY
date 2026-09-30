    import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      debugPrint('HomeCubit getHome failed: ${failure.errMessage}');
      emit(GetHomeDataError(failure.errMessage));
    }, (data) {
      homeModel = data;
       emit(GetHomeDataSuccess(data));
    });
  }


}
