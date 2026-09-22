import '../../data/models/my_ads_data_model.dart';

abstract class AdvertisementsStates{}

class AdvertisementsInitState extends AdvertisementsStates{}

class ChangeAdvertisementsTypeIndexState extends AdvertisementsStates{}

class GetAllMyAdsDataLoadingState extends AdvertisementsStates{}
class GetAllMyAdsDataSuccessState extends AdvertisementsStates{
  final MyAdsDataModel adsDataModel;
  GetAllMyAdsDataSuccessState(this.adsDataModel);
}
class GetAllMyAdsDataErrorState extends AdvertisementsStates{
  final String error;
  GetAllMyAdsDataErrorState(this.error);

}