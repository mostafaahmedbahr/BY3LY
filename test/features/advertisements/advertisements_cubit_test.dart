import 'package:by3ly/features/advertisements/data/models/my_ads_data_model.dart';
import 'package:by3ly/features/advertisements/data/models/pause_resume_ad_model.dart';
import 'package:by3ly/features/advertisements/data/repos/advertisements_repos.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_cubit.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_states.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory fake of the repository with configurable outcomes.
class FakeAdvertisementsRepo implements AdvertisementsRepo {
  int fetchCalls = 0;
  int deleteCalls = 0;
  int pauseCalls = 0;
  int resumeCalls = 0;

  bool fetchShouldFail = false;
  bool deleteShouldFail = false;
  bool pauseShouldFail = false;

  static final _seedAds = <Ads>[
    Ads(
      id: 1,
      name: 'دراجة فيدرالية',
      desc: 'دراجة بحالة ممتازة',
      isPaused: false,
      rate: 5,
      countCommenets: 3,
      reviewsCount: 10,
    ),
    Ads(
      id: 2,
      name: 'تلفزيون سامسونج',
      desc: 'شاشة LED 55 بوصة',
      isPaused: true,
      rate: 4,
      countCommenets: 1,
      reviewsCount: 4,
    ),
    Ads(
      id: 3,
      name: 'آيفون 15',
      desc: 'iPhone 15 Pro Max 265GB - آيفون برو',
      isPaused: false,
      rate: 0,
      countCommenets: 0,
      reviewsCount: 0,
    ),
  ];

  MyAdsDataModel _model() => MyAdsDataModel(
        status: true,
        message: 'ok',
        data: Data(
          ads: _seedAds
              .map((a) => Ads.fromJson(a.toJson()))
              .toList(),
        ),
      );

  @override
  Future<Either<Failure, MyAdsDataModel>> getMyAdsData() async {
    fetchCalls++;
    if (fetchShouldFail) {
      return Left(ServerFailure('fetch failed'));
    }
    return Right(_model());
  }

  @override
  Future<Either<Failure, GeneralModel>> deleteAd({required int adId}) async {
    deleteCalls++;
    if (deleteShouldFail) {
      return Left(ServerFailure('delete failed'));
    }
    return Right(GeneralModel(status: true, message: 'deleted'));
  }

  @override
  Future<Either<Failure, PauseResumeAdModel>> pauseAd({required int adId}) async {
    pauseCalls++;
    // Small delay so concurrent callers overlap in time.
    await Future<void>.delayed(const Duration(milliseconds: 60));
    if (pauseShouldFail) {
      return Left(ServerFailure('pause failed'));
    }
    return Right(
      PauseResumeAdModel(
        status: true,
        message: 'paused',
        data: PauseResumeAdData(adId: adId, isPaused: true, status: 0),
      ),
    );
  }

  @override
  Future<Either<Failure, PauseResumeAdModel>> resumeAd({required int adId}) async {
    resumeCalls++;
    return Right(
      PauseResumeAdModel(
        status: true,
        message: 'resumed',
        data: PauseResumeAdData(adId: adId, isPaused: false, status: 1),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('initial state is AdvertisementsInitState', () {
    final cubit = AdvertisementsCubit(FakeAdvertisementsRepo());
    expect(cubit.state, isA<AdvertisementsInitState>());
    cubit.close();
  });

  test('fetchMyAds populates the list and counters', () async {
    final repo = FakeAdvertisementsRepo();
    final cubit = AdvertisementsCubit(repo);

    await cubit.fetchMyAds();

    expect(repo.fetchCalls, 1);
    expect(cubit.state, isA<GetAllMyAdsDataSuccessState>());
    expect(cubit.allAdsCount, 3);
    expect(cubit.activeAdsCount, 2);
    expect(cubit.inactiveAdsCount, 1);
    expect(cubit.countForTab(0), 3);
    expect(cubit.countForTab(1), 2);
    expect(cubit.countForTab(2), 1);
    await cubit.close();
  });

  test('fetchMyAds failure emits GetAllMyAdsDataErrorState', () async {
    final repo = FakeAdvertisementsRepo()..fetchShouldFail = true;
    final cubit = AdvertisementsCubit(repo);

    await cubit.fetchMyAds();

    expect(cubit.state, isA<GetAllMyAdsDataErrorState>());
    expect(cubit.allAdsCount, 0);
    await cubit.close();
  });

  test('filteredAds filters by tab index', () async {
    final cubit = AdvertisementsCubit(FakeAdvertisementsRepo());
    await cubit.fetchMyAds();

    cubit.setAdvertisementsTypeIndex(1); // active
    expect(cubit.filteredAds().map((a) => a.id), [1, 3]);

    cubit.setAdvertisementsTypeIndex(2); // inactive
    expect(cubit.filteredAds().map((a) => a.id), [2]);

    cubit.setAdvertisementsTypeIndex(0); // all
    expect(cubit.filteredAds().map((a) => a.id), [1, 2, 3]);
    await cubit.close();
  });

  test('filteredAds searches name and description case-insensitively', () async {
    final cubit = AdvertisementsCubit(FakeAdvertisementsRepo());
    await cubit.fetchMyAds();

    cubit.setSearchQuery('سامسونج');
    expect(cubit.filteredAds().map((a) => a.id), [2]);

    cubit.setSearchQuery('IPHONE');
    expect(cubit.filteredAds().map((a) => a.id), [3]);

    cubit.setSearchQuery('آيفون');
    expect(cubit.filteredAds().map((a) => a.id), [3]);

    cubit.setSearchQuery('   ');
    expect(cubit.filteredAds().length, 3);
    await cubit.close();
  });

  test('filteredAds combines tab and search', () async {
    final cubit = AdvertisementsCubit(FakeAdvertisementsRepo());
    await cubit.fetchMyAds();

    cubit.setAdvertisementsTypeIndex(1); // active tab
    cubit.setSearchQuery('آيفون');
    expect(cubit.filteredAds().map((a) => a.id), [3]);

    cubit.setSearchQuery('سامسونج');
    expect(cubit.filteredAds(), isEmpty);
    await cubit.close();
  });

  test('pauseAd success flips the cached ad to paused and emits success',
      () async {
    final repo = FakeAdvertisementsRepo();
    final cubit = AdvertisementsCubit(repo);
    await cubit.fetchMyAds();

    await cubit.pauseAd(adId: 1);

    expect(repo.pauseCalls, 1);
    expect(cubit.state, isA<PauseResumeAdSuccessState>());
    expect(
      cubit.allMyAdsList.firstWhere((a) => a.id == 1).isPaused,
      isTrue,
    );
    expect(cubit.activeAdsCount, 1);
    expect(cubit.inactiveAdsCount, 2);
    await cubit.close();
  });

  test('resumeAd success flips the cached ad to active', () async {
    final repo = FakeAdvertisementsRepo();
    final cubit = AdvertisementsCubit(repo);
    await cubit.fetchMyAds(); // ad id 2 starts paused

    await cubit.resumeAd(adId: 2);

    expect(repo.resumeCalls, 1);
    expect(cubit.state, isA<PauseResumeAdSuccessState>());
    expect(
      cubit.allMyAdsList.firstWhere((a) => a.id == 2).isPaused,
      isFalse,
    );
    await cubit.close();
  });

  test('pauseAd failure emits error and keeps the list untouched', () async {
    final repo = FakeAdvertisementsRepo()..pauseShouldFail = true;
    final cubit = AdvertisementsCubit(repo);
    await cubit.fetchMyAds();

    await cubit.pauseAd(adId: 1);

    expect(cubit.state, isA<PauseResumeAdErrorState>());
    expect(
      cubit.allMyAdsList.firstWhere((a) => a.id == 1).isPaused,
      isFalse,
    );
    await cubit.close();
  });

  test('concurrent pause calls trigger only one network request', () async {
    final repo = FakeAdvertisementsRepo();
    final cubit = AdvertisementsCubit(repo);
    await cubit.fetchMyAds();

    final first = cubit.pauseAd(adId: 1);
    final second = cubit.pauseAd(adId: 1);
    await Future.wait([first, second]);

    expect(repo.pauseCalls, 1);
    await cubit.close();
  });

  test('deleteAd success removes the ad from the list and emits success',
      () async {
    final repo = FakeAdvertisementsRepo();
    final cubit = AdvertisementsCubit(repo);
    await cubit.fetchMyAds();

    await cubit.deleteAd(adId: 1);

    expect(repo.deleteCalls, 1);
    expect(cubit.state, isA<DeleteAdSuccessState>());
    expect(cubit.allMyAdsList.map((a) => a.id), [2, 3]);
    expect(cubit.allAdsCount, 2);
    await cubit.close();
  });

  test('deleteAd failure keeps the ad and emits error', () async {
    final repo = FakeAdvertisementsRepo()..deleteShouldFail = true;
    final cubit = AdvertisementsCubit(repo);
    await cubit.fetchMyAds();

    await cubit.deleteAd(adId: 1);

    expect(cubit.state, isA<DeleteAdErrorState>());
    expect(cubit.allMyAdsList.map((a) => a.id), [1, 2, 3]);
    await cubit.close();
  });
}
