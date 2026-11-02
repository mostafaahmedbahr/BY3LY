import '../../data/models/my_ads_data_model.dart';

abstract class AdvertisementsStates {}

class AdvertisementsInitState extends AdvertisementsStates {}

class ChangeAdvertisementsTypeIndexState extends AdvertisementsStates {}

class GetAllMyAdsDataLoadingState extends AdvertisementsStates {
  @override
  String toString() => 'GetAllMyAdsDataLoadingState';
}

class GetAllMyAdsDataSuccessState extends AdvertisementsStates {
  final MyAdsDataModel adsDataModel;
  GetAllMyAdsDataSuccessState(this.adsDataModel);

  @override
  String toString() =>
      'GetAllMyAdsDataSuccessState(status: ${adsDataModel.status})';
}

class GetAllMyAdsDataErrorState extends AdvertisementsStates {
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
  final int adId;
  final String? message;
  DeleteAdSuccessState(this.adId, this.message);

  @override
  String toString() => 'DeleteAdSuccessState(adId: $adId)';
}

class DeleteAdErrorState extends AdvertisementsStates {
  final String error;
  final int? adId;
  DeleteAdErrorState(this.error, {this.adId});

  @override
  String toString() => 'DeleteAdErrorState(error: $error)';
}

/// Emitted while a pause/resume request is in flight for [adId].
///
/// [pause] is `true` when the request is "pauseAd" and `false` when it is
/// "resumeAd"; the UI uses it to show the correct spinner/label.
class PauseResumeAdLoadingState extends AdvertisementsStates {
  final int adId;
  final bool pause;
  PauseResumeAdLoadingState(this.adId, {required this.pause});

  @override
  String toString() => 'PauseResumeAdLoadingState(adId: $adId, pause: $pause)';
}

class PauseResumeAdSuccessState extends AdvertisementsStates {
  final int adId;

  /// New backend value of `is_paused` (true = paused / غير نشط).
  final bool isPaused;
  final String? message;
  PauseResumeAdSuccessState(this.adId, this.isPaused, this.message);

  @override
  String toString() =>
      'PauseResumeAdSuccessState(adId: $adId, isPaused: $isPaused)';
}

class PauseResumeAdErrorState extends AdvertisementsStates {
  final String error;
  final int adId;
  PauseResumeAdErrorState(this.error, {required this.adId});

  @override
  String toString() => 'PauseResumeAdErrorState(adId: $adId, error: $error)';
}
