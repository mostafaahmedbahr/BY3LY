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

  /// Page size used when talking to the backend, and for the local fallback
  /// when `getAllAds` does not report pagination info.
  static const int adsPerPage = 10;

  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool get hasMore => currentPage < lastPage;

  int advertisementsTypeIndex = 0;

  void setAdvertisementsTypeIndex(int index) {
    advertisementsTypeIndex = index;
    emit(ChangeAdvertisementsTypeIndexState());
  }

  /// Tab labels: 0 = all, 1 = active, 2 = inactive.
  List<String> get types => ['all', 'activeNow', 'inactiveAd'];

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
        logWarning(
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
        logWarning(
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

  /// Fetches one page of the seller's ads from the server.
  ///
  /// `loadMore: false` (default) resets to page 1 and replaces the list —
  /// this is what pull-to-refresh and every "refresh after edit" call use.
  /// `loadMore: true` appends the next page and keeps the current items.
  Future<void> fetchMyAds({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return;
      isLoadingMore = true;
      emit(GetAllMyAdsDataPaginatingState());
    } else {
      currentPage = 1;
      lastPage = 1;
      allMyAdsList = [];
      emit(GetAllMyAdsDataLoadingState());
    }

    final page = loadMore ? currentPage + 1 : 1;
    final result = await advertisementsRepo.getMyAdsData(
      page: page,
      perPage: adsPerPage,
    );
    return result.fold(
      (failure) {
        logWarning(
          'AdvertisementsCubit fetchMyAds failed: ${failure.errMessage}',
        );
        isLoadingMore = false;
        if (loadMore) {
          emit(GetAllMyAdsDataPaginationErrorState(failure.errMessage));
        } else {
          emit(GetAllMyAdsDataErrorState(failure.errMessage));
        }
      },
      (data) {
        isLoadingMore = false;
        myAdsDataModel = data;
        if (data.status != true) {
          final msg = data.message ?? 'Something went wrong';
          if (loadMore) {
            emit(GetAllMyAdsDataPaginationErrorState(msg));
          } else {
            emit(GetAllMyAdsDataErrorState(msg));
          }
          return;
        }

        final rawAds = data.data?.ads ?? [];
        final pagination = data.data?.pagination;
        late final List<Ads> pageAds;
        if (pagination != null) {
          // Backend paginated the response: trust its numbers and use every
          // item it returned for this page.
          currentPage = pagination.currentPage ?? page;
          lastPage =
              pagination.resolvedLastPage ??
              // Last resort: derive it from the total when neither key came.
              (pagination.total != null && (pagination.perPage ?? 0) > 0
                  ? (pagination.total! / pagination.perPage!).ceil()
                  : page);
          if (lastPage < 1) lastPage = 1;
          pageAds = rawAds;
        } else {
          // Backend ignored `page`: emulate pagination over the full list
          // so the UI still loads page by page instead of dumping everything.
          currentPage = page;
          lastPage = (rawAds.length / adsPerPage).ceil();
          if (lastPage < 1) lastPage = 1;
          final start = (page - 1) * adsPerPage;
          pageAds = rawAds.skip(start).take(adsPerPage).toList();
        }

        if (loadMore) {
          allMyAdsList = [...allMyAdsList, ...pageAds];
        } else {
          allMyAdsList = [...pageAds];
        }
        logSuccess('page=$page/$lastPage ads=${allMyAdsList.length}');
        emit(GetAllMyAdsDataSuccessState(data));
      },
    );
  }
}
