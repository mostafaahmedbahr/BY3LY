import '../../data/models/my_ads_data_model.dart';

abstract class AdvertisementsStates{}

class AdvertisementsInitState extends AdvertisementsStates{}

class ChangeAdvertisementsTypeIndexState extends AdvertisementsStates{}

class GetAllMyAdsDataLoadingState extends AdvertisementsStates {
  @override
  String toString() => 'GetAllMyAdsDataLoadingState';
}
class GetAllMyAdsDataSuccessState extends AdvertisementsStates{
  final MyAdsDataModel adsDataModel;
  GetAllMyAdsDataSuccessState(this.adsDataModel);

  @override
  String toString() =>
      'GetAllMyAdsDataSuccessState(status: ${adsDataModel.status})';
}
class GetAllMyAdsDataErrorState extends AdvertisementsStates{
  final String error;
  GetAllMyAdsDataErrorState(this.error);

  @override
  String toString() => 'GetAllMyAdsDataErrorState(error: $error)';

}

class DeleteAdLoadingState extends AdvertisementsStates {
  final int adId;
  DeleteAdLoadingState(this.adId);

  @override
  String toString() => 'DeleteAdLoadingState(adId: $adId)';
}

class DeleteAdSuccessState extends AdvertisementsStates {
  final String? message;
  DeleteAdSuccessState(this.message);

  @override
  String toString() => 'DeleteAdSuccessState(message: $message)';
}

class DeleteAdErrorState extends AdvertisementsStates {
  final String error;
  DeleteAdErrorState(this.error);

  @override
  String toString() => 'DeleteAdErrorState(error: $error)';
}