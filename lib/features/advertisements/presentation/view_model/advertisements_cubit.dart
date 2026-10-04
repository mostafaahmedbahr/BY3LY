
import 'package:by3ly/core/extensions/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/my_ads_data_model.dart';
import '../../data/repos/advertisements_repos.dart';
import 'advertisements_states.dart';

class AdvertisementsCubit extends Cubit<AdvertisementsStates> {
  AdvertisementsCubit(this.advertisementsRepo) : super(AdvertisementsInitState());

  static AdvertisementsCubit get(context) => BlocProvider.of(context);

  AdvertisementsRepo? advertisementsRepo;
  MyAdsDataModel? myAdsDataModel;

  List<Ads> allMyAdsList = [];

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
    final query = searchQuery.trim().toLowerCase();
    final byTab = switch (advertisementsTypeIndex) {
      1 => allMyAdsList.where(_isActive).toList(),
      2 => allMyAdsList.where((ad) => !_isActive(ad)).toList(),
      _ => allMyAdsList,
    };
    if (query.isEmpty) return byTab;
    return byTab.where((ad) {
      final name = (ad.name ?? '').toLowerCase();
      final desc = (ad.desc ?? '').toLowerCase();
      return name.contains(query) || desc.contains(query);
    }).toList();
  }

  String searchQuery = '';

  void setSearchQuery(String query) {
    searchQuery = query;
    emit(ChangeAdvertisementsTypeIndexState());
  }

  int? deletingAdId;

  Future<void> deleteAd({required int adId}) async {
    deletingAdId = adId;
    emit(DeleteAdLoadingState(adId));
    var result = await advertisementsRepo!.deleteAd(adId: adId);
    return result.fold((failure) {
      debugPrint('AdvertisementsCubit deleteAd failed: ${failure.errMessage}');
      deletingAdId = null;
      emit(DeleteAdErrorState(failure.errMessage, adId: adId));
    }, (data) {
      deletingAdId = null;
      if (data.status == true) {
        allMyAdsList.removeWhere((ad) => ad.id == adId);
        emit(DeleteAdSuccessState(adId, data.message));
      } else {
        emit(DeleteAdErrorState(
            data.message ?? 'Something went wrong',
            adId: adId));
      }
    });
  }

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
