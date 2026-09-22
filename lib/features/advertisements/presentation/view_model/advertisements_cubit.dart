
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/my_ads_data_model.dart';
import '../../data/repos/advertisements_repos.dart';
import 'advertisements_states.dart';

class AdvertisementsCubit extends Cubit<AdvertisementsStates> {
  AdvertisementsCubit(this.advertisementsRepo) : super(AdvertisementsInitState());

  static AdvertisementsCubit get(context) => BlocProvider.of(context);


  int advertisementsTypeIndex = 0 ;
  changeAdvertisementsTypeIndexWay(index)
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

  List<Products> allMyAdsList=[];
  Future<void> getAllMyAdsDataMethod({
    required int type,
}) async {
    allMyAdsList = [];
    emit(GetAllMyAdsDataLoadingState());
    var result = await advertisementsRepo!.getMyAdsData(type: type);
    return result.fold((failure) {
      emit(GetAllMyAdsDataErrorState(failure.errMessage));
    }, (data) {
      myAdsDataModel = data;
      allMyAdsList = allMyAdsList + myAdsDataModel!.data!.products!;
      print(allMyAdsList.length);
      print("length");
      emit(GetAllMyAdsDataSuccessState(data));
    });
  }
}