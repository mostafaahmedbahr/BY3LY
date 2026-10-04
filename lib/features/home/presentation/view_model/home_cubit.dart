    import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/banners_model.dart';
import '../../data/models/home_model.dart';
import '../../data/repos/home_repo.dart';
import 'home_states.dart';


class HomeCubit extends Cubit<HomeStates> {
    HomeCubit(this.homeRepo) : super(HomeInitState());

    static HomeCubit get(context) => BlocProvider.of(context);

  HomeRepo? homeRepo;
  HomeModel? homeModel;

  BannersModel? bannersModel;

  /// Slider banners shown above the search (empty-image items dropped).
  List<BannerItem> get banners => (bannersModel?.banners ?? [])
      .where((b) => (b.image?.trim().isNotEmpty ?? false))
      .toList();


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

  Future<void> getBanners() async {
    final hadBanners = banners.isNotEmpty;
    if (!hadBanners) emit(GetBannersLoading());
    var result = await homeRepo!.getBanners();
    return result.fold((failure) {
      debugPrint('HomeCubit getBanners failed: ${failure.errMessage}');
      // Silent fail when we already show banners; full error only
      // when there is nothing to display.
      if (hadBanners) return;
      emit(GetBannersError(failure.errMessage));
    }, (data) {
      bannersModel = data;
      emit(GetBannersSuccess());
    });
  }


}
