import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/allSubCategories/data/models/all_sub_categories_model.dart';
import 'package:by3ly/features/allSubCategories/data/repos/all_sub_categories_repos.dart';
import 'package:by3ly/features/allSubCategories/presentation/view_model/all_sub_categories_cubit.dart';
import 'package:by3ly/features/allSubCategories/presentation/view_model/all_sub_categories_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory fake repo with configurable outcome and call counting
/// per category.
class FakeAllSubCategoriesRepo implements AllSubCategoriesRepos {
  int calls = 0;
  bool shouldFail = false;

  static final _sample = <SubCategories>[
    SubCategories(id: 11, name: 'ملاكي', image: 'a.jpg', productsCount: 5),
    SubCategories(id: 12, name: 'مانيوال', image: 'b.jpg', productsCount: 2),
  ];

  AllSubCategoriesModel _build() => AllSubCategoriesModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'subCategories': _sample.map((e) => e.toJson()).toList(),
        },
      });

  @override
  Future<Either<Failure, AllSubCategoriesModel>>
      getAllSubCategoriesData({required int categoryId}) async {
    calls++;
    await Future<void>.delayed(const Duration(milliseconds: 40));
    if (shouldFail) {
      return Left(ServerFailure('fetch failed for $categoryId'));
    }
    return Right(_build());
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    AllSubCategoriesCubit.clearCache();
  });

  test('initial state is AllSubCategoriesInitState', () {
    final cubit = AllSubCategoriesCubit(FakeAllSubCategoriesRepo());
    expect(cubit.state, isA<AllSubCategoriesInitState>());
    cubit.close();
  });

  test('fetch success populates the list, caches and emits Success',
      () async {
    final repo = FakeAllSubCategoriesRepo();
    final cubit = AllSubCategoriesCubit(repo);

    await cubit.getAllSubCategories(categoryId: 1);

    expect(repo.calls, 1);
    expect(cubit.state, isA<GetAllSubCategoriesSuccess>());
    expect(cubit.allSubCategoriesList.length, 2);
    expect(
      AllSubCategoriesCubit.cachedFor(1),
      isNotNull,
    );
    await cubit.close();
  });

  test(
      'second fetch on the same category is served from cache',
      () async {
    final repo = FakeAllSubCategoriesRepo();
    final first = AllSubCategoriesCubit(repo);
    await first.getAllSubCategories(categoryId: 1);
    await first.close();

    final second = AllSubCategoriesCubit(repo);
    await second.getAllSubCategories(categoryId: 1);

    expect(repo.calls, 1);
    expect(second.allSubCategoriesList.length, 2);
    expect(second.state, isA<GetAllSubCategoriesSuccess>());
    await second.close();
  });

  test('cache is per-category — a different category triggers a fetch',
      () async {
    final repo = FakeAllSubCategoriesRepo();
    final cubit = AllSubCategoriesCubit(repo);

    await cubit.getAllSubCategories(categoryId: 1);
    await cubit.getAllSubCategories(categoryId: 2);

    expect(repo.calls, 2);
    await cubit.close();
  });

  test('forceRefresh bypasses the cache', () async {
    final repo = FakeAllSubCategoriesRepo();
    final first = AllSubCategoriesCubit(repo);
    await first.getAllSubCategories(categoryId: 1);
    await first.close();

    final second = AllSubCategoriesCubit(repo);
    await second.getAllSubCategories(categoryId: 1, forceRefresh: true);

    expect(repo.calls, 2);
    await second.close();
  });

  test('failure emits GetAllSubCategoriesError and keeps list empty',
      () async {
    final repo = FakeAllSubCategoriesRepo()..shouldFail = true;
    final cubit = AllSubCategoriesCubit(repo);

    await cubit.getAllSubCategories(categoryId: 1);

    expect(cubit.state, isA<GetAllSubCategoriesError>());
    expect(cubit.allSubCategoriesList, isEmpty);
    await cubit.close();
  });

  test('concurrent calls share a single in-flight request', () async {
    final repo = FakeAllSubCategoriesRepo();
    final cubit = AllSubCategoriesCubit(repo);

    final a = cubit.getAllSubCategories(categoryId: 1);
    final b = cubit.getAllSubCategories(categoryId: 1);
    await Future.wait([a, b]);

    expect(repo.calls, 1);
    expect(cubit.state, isA<GetAllSubCategoriesSuccess>());
    await cubit.close();
  });
}
