
import 'package:by3ly/core/extensions/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/my_ads_data_model.dart';
import '../../data/repos/advertisements_repos.dart';
import 'advertisements_states.dart';

class AdvertisementsCubit extends Cubit<AdvertisementsStates> {
  AdvertisementsCubit(this.advertisementsRepo) : super(AdvertisementsInitState());

  static AdvertisementsCubit get(context) => BlocProvider.of(context);


  int advertisementsTypeIndex = 0 ;
  void changeAdvertisementsTypeIndexWay(index)
  {
    advertisementsTypeIndex = index;
    print(advertisementsTypeIndex);
    emit(ChangeAdvertisementsTypeIndexState());
  }


  List<String> types = [
    "الكل",
    "النشط الان",
    "الغير نشط",
  ];

  /// Backend rule: is_paused == true  -> paused (غير نشط),
  ///               anything else      -> active (نشط).
  bool _isActive(Ads ad) => ad.isPaused != true;

  int get allAdsCount => allMyAdsList.length;

  int get activeAdsCount => allMyAdsList.where(_isActive).length;

  int get inactiveAdsCount => allMyAdsList.length - activeAdsCount;

  int countForTab(int index) {
    switch (index) {
      case 1:
        return activeAdsCount;
      case 2:
        return inactiveAdsCount;
      default:
        return allAdsCount;
    }
  }

  List<Ads> filteredAds() {
    switch (advertisementsTypeIndex) {
      case 1:
        return allMyAdsList.where(_isActive).toList();
      case 2:
        return allMyAdsList.where((ad) => !_isActive(ad)).toList();
      default:
        return allMyAdsList;
    }
  }


  AdvertisementsRepo? advertisementsRepo;
  MyAdsDataModel? myAdsDataModel;

  List<Ads> allMyAdsList=[];
  Future<void> getAllMyAdsDataMethod({
    required int type,
}) async {
    allMyAdsList = [];
    emit(GetAllMyAdsDataLoadingState());
    var result = await advertisementsRepo!.getMyAdsData( );
    return result.fold((failure) {
      debugPrint('AdvertisementsCubit getAllMyAdsDataMethod failed: ${failure.errMessage}');
      emit(GetAllMyAdsDataErrorState(failure.errMessage));
    }, (data) {
      myAdsDataModel = data;
      allMyAdsList = [...?myAdsDataModel?.data?.ads];
      logSuccess(allMyAdsList.length.toString());
      logSuccess("length");
      emit(GetAllMyAdsDataSuccessState(data));
    });
  }
}