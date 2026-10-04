
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
    "السابقة",
  ];


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