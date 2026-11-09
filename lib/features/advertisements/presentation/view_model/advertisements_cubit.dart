import 'package:by3ly/core/extensions/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/my_ads_data_model.dart';
import '../../data/repos/advertisements_repos.dart';
import 'advertisements_states.dart';

class AdvertisementsCubit extends Cubit<AdvertisementsStates> {
  AdvertisementsCubit(this.advertisementsRepo)
      : super(AdvertisementsInitState());

  static AdvertisementsCubit get(BuildContext context) =>
      BlocProvider.of<AdvertisementsCubit>(context);

  final AdvertisementsRepo advertisementsRepo;
  MyAdsDataModel? myAdsDataModel;

  List<Ads> allMyAdsList = [];

  int advertisementsTypeIndex = 0;

  void setAdvertisementsTypeIndex(int index) {
    advertisementsTypeIndex = index;
    emit(ChangeAdvertisementsTypeIndexState());
  }

  /// Tab labels: 0 = all, 1 = active, 2 = inactive.
  List<String> get types => [
        'all',
        'activeNow',
        'inactiveAd',
      ];

  /// Backend rule: is_paused == true  -> paused (inactive),
  ///               anything else      -> active.
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
    final result = await advertisementsRepo.deleteAd(adId: adId);
    return result.fold(
      (failure) {
        debugPrint(
          'AdvertisementsCubit deleteAd failed: ${failure.errMessage}',
        );
        deletingAdId = null;
        emit(DeleteAdErrorState(failure.errMessage, adId: adId));
      },
      (data) {
        deletingAdId = null;
        if (data.status == true) {
          allMyAdsList.removeWhere((ad) => ad.id == adId);
          emit(DeleteAdSuccessState(adId, data.message));
        } else {
          emit(
            DeleteAdErrorState(
              data.message ?? 'Something went wrong',
              adId: adId,
            ),
          );
        }
      },
    );
  }

  /// Ads with a pause/resume request in flight. Prevents double taps and
  /// lets every card know when its own request is running.
  final Set<int> _pauseResumeInFlight = {};

  bool isPauseResumeLoading(int adId) => _pauseResumeInFlight.contains(adId);

  /// Pauses the seller's own ad so it is no longer visible to others.
  Future<void> pauseAd({required int adId}) {
    return _changePauseState(adId: adId, pause: true);
  }

  /// Resumes a paused ad so it becomes visible to others again.
  Future<void> resumeAd({required int adId}) {
    return _changePauseState(adId: adId, pause: false);
  }

  Future<void> _changePauseState({
    required int adId,
    required bool pause,
  }) async {
    if (_pauseResumeInFlight.contains(adId)) return;
    _pauseResumeInFlight.add(adId);
    emit(PauseResumeAdLoadingState(adId, pause: pause));

    final result = pause
        ? await advertisementsRepo.pauseAd(adId: adId)
        : await advertisementsRepo.resumeAd(adId: adId);

    _pauseResumeInFlight.remove(adId);
    if (isClosed) return;

    return result.fold(
      (failure) {
        debugPrint(
          'AdvertisementsCubit ${pause ? 'pauseAd' : 'resumeAd'} failed: '
          '${failure.errMessage}',
        );
        emit(PauseResumeAdErrorState(failure.errMessage, adId: adId));
      },
      (data) {
        if (data.status != true) {
          emit(
            PauseResumeAdErrorState(
              data.message ?? 'Something went wrong',
              adId: adId,
            ),
          );
          return;
        }
        // Trust the backend value; fall back to the requested action when the
        // payload omits `is_paused`.
        final isPaused = data.data?.isPaused ?? pause;
        _applyPauseState(adId: adId, isPaused: isPaused);
        emit(PauseResumeAdSuccessState(adId, isPaused, data.message));
      },
    );
  }

  /// Mirrors the backend result into the cached list so status badges, tabs
  /// and counters update without a full network reload.
  void _applyPauseState({required int adId, required bool isPaused}) {
    for (final ad in allMyAdsList) {
      if (ad.id == adId) ad.isPaused = isPaused;
    }
    final modelAds = myAdsDataModel?.data?.ads;
    if (modelAds != null) {
      for (final ad in modelAds) {
        if (ad.id == adId) ad.isPaused = isPaused;
      }
    }
  }

  /// Fetches the full ads list from the server (single source of truth).
  Future<void> fetchMyAds() async {
    allMyAdsList = [];
    emit(GetAllMyAdsDataLoadingState());
    final result = await advertisementsRepo.getMyAdsData();
    return result.fold(
      (failure) {
        debugPrint(
          'AdvertisementsCubit fetchMyAds failed: ${failure.errMessage}',
        );
        emit(GetAllMyAdsDataErrorState(failure.errMessage));
      },
      (data) {
        myAdsDataModel = data;
        allMyAdsList = [...?myAdsDataModel?.data?.ads];
        logSuccess(allMyAdsList.length.toString());
        logSuccess('length');
        emit(GetAllMyAdsDataSuccessState(data));
      },
    );
  }
}
