import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/chooseLocation/data/models/choose_location_model.dart';
import 'package:by3ly/features/chooseLocation/data/models/cities_centers_model.dart';
import 'package:by3ly/features/chooseLocation/data/repos/choose_location_repos.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_cubit.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory fake repo with call counting and configurable outcomes.
class FakeChooseLocationRepos implements ChooseLocationRepos {
  int getCalls = 0;
  int postCalls = 0;
  bool fetchShouldFail = false;
  bool postShouldFail = false;

  static final _fixture = AllCitiesAndCentersModel.fromJson({
    'status': true,
    'message': 'ok',
    'data': {
      'cities': [
        {
          'id': 1,
          'name': 'القاهرة',
          'centers': [
            {'id': 11, 'name': 'مدينة نصر'},
            {'id': 12, 'name': 'المعادي'},
          ],
        },
        {
          'id': 2,
          'name': 'الجيزة',
          'centers': [
            {'id': 21, 'name': 'الدقي'},
          ],
        },
        {
          'id': 3,
          'name': 'إسكندرية',
          'centers': <Map<String, dynamic>>[],
        },
      ],
    },
  });

  @override
  Future<Either<Failure, AllCitiesAndCentersModel>>
      getAllCitiesAndCentersData() async {
    getCalls++;
    if (fetchShouldFail) {
      return Left(ServerFailure('offline'));
    }
    return Right(_fixture);
  }

  @override
  Future<Either<Failure, ChooseLocationModel>> chooseLocationCityAndCenter({
    required int cityId,
    required int centerId,
  }) async {
    postCalls++;
    if (postShouldFail) {
      return Left(ServerFailure('save failed'));
    }
    return Right(ChooseLocationModel(
      status: true,
      number: 1,
      message: 'تم الحفظ',
    ));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Fetch cities & centers', () {
    test('initial state is ChooseLocationInitState', () {
      final cubit = ChooseLocationCubit(FakeChooseLocationRepos());
      expect(cubit.state, isA<ChooseLocationInitState>());
      cubit.close();
    });

    test('fetch success populates cities and exposes first city centers',
        () async {
      final repo = FakeChooseLocationRepos();
      final cubit = ChooseLocationCubit(repo);

      await cubit.getAllCitiesAndCenters();

      expect(repo.getCalls, 1);
      expect(cubit.state, isA<GetAllCitiesAndCentersSuccess>());
      expect(cubit.allCitiesList.length, 3);
      expect(cubit.allCitiesList.first.centers!.length, 2);
      expect(cubit.allCentersList.length, 2);
      await cubit.close();
    });

    test('fetch failure emits error state and keeps list empty', () async {
      final repo = FakeChooseLocationRepos()..fetchShouldFail = true;
      final cubit = ChooseLocationCubit(repo);

      await cubit.getAllCitiesAndCenters();

      expect(cubit.state, isA<GetAllCitiesAndCentersError>());
      expect(cubit.allCitiesList, isEmpty);
      await cubit.close();
    });
  });

  group('Selection flow', () {
    late ChooseLocationCubit cubit;

    setUp(() async {
      cubit = ChooseLocationCubit(FakeChooseLocationRepos());
      await cubit.getAllCitiesAndCenters();
    });

    tearDown(() async => cubit.close());

    test('chooseCity marks city as selected and clears center', () {
      cubit.chooseCity('القاهرة', 1);
      expect(cubit.countryIsSelect, isTrue);
      expect(cubit.selectedCity, 'القاهرة');
      expect(cubit.selectedCityId, 1);
      expect(cubit.selectedCenter, '');
      expect(cubit.selectedCenterId, 0);
      expect(cubit.centerIsSelect, isFalse);
    });

    test('chooseCenter marks center as selected', () {
      cubit.chooseCity('القاهرة', 1);
      cubit.filterCentersByCity(1);
      cubit.chooseCenter('مدينة نصر', 11);
      expect(cubit.centerIsSelect, isTrue);
      expect(cubit.selectedCenter, 'مدينة نصر');
      expect(cubit.selectedCenterId, 11);
    });

    test('filterCentersByCity updates centers list', () {
      cubit.filterCentersByCity(2);
      expect(cubit.allCentersList.length, 1);
      expect(cubit.allCentersList.first.name, 'الدقي');

      cubit.filterCentersByCity(3);
      expect(cubit.allCentersList, isEmpty);
    });

    test('filterCentersByCity unknown id yields empty centers list', () {
      cubit.filterCentersByCity(999);
      expect(cubit.allCentersList, isEmpty);
    });

    test('resetSelection clears city, center and flags', () {
      cubit.chooseCity('القاهرة', 1);
      cubit.chooseCenter('مدينة نصر', 11);
      cubit.resetSelection();
      expect(cubit.countryIsSelect, isFalse);
      expect(cubit.centerIsSelect, isFalse);
      expect(cubit.selectedCity, '');
      expect(cubit.selectedCenter, '');
      expect(cubit.selectedCityId, 0);
      expect(cubit.selectedCenterId, 0);
      expect(cubit.allCentersList, isEmpty);
    });

    test('resetCenterSelection clears only center, keeps city', () {
      cubit.chooseCity('القاهرة', 1);
      cubit.filterCentersByCity(1);
      cubit.chooseCenter('مدينة نصر', 11);
      cubit.resetCenterSelection();
      expect(cubit.centerIsSelect, isFalse);
      expect(cubit.selectedCenter, '');
      expect(cubit.selectedCenterId, 0);
      expect(cubit.selectedCity, 'القاهرة');
      expect(cubit.countryIsSelect, isTrue);
    });
  });

  group('addLocation', () {
    test('success emits AddLocationCitiesAndCentersSuccess', () async {
      final repo = FakeChooseLocationRepos();
      final cubit = ChooseLocationCubit(repo);

      await cubit.addLocationCityAndCenter(cityId: 1, centerId: 11);

      expect(repo.postCalls, 1);
      expect(cubit.state, isA<AddLocationCitiesAndCentersSuccess>());
      expect(cubit.chooseLocationModel?.status, isTrue);
      await cubit.close();
    });

    test('failure emits AddLocationCitiesAndCentersError', () async {
      final repo = FakeChooseLocationRepos()..postShouldFail = true;
      final cubit = ChooseLocationCubit(repo);

      await cubit.addLocationCityAndCenter(cityId: 1, centerId: 11);

      expect(cubit.state, isA<AddLocationCitiesAndCentersError>());
      await cubit.close();
    });
  });
}
