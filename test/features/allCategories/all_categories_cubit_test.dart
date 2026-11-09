import 'package:by3ly/features/allCategories/data/models/all_categories_model.dart';
import 'package:by3ly/features/allCategories/data/repos/all_categories_repo.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/all_categories_cubit.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/all_categories_states.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory fake repo with configurable outcome and call counting.
class FakeAllCategoriesRepo implements AllCategoriesRepo {
  int calls = 0;
  bool shouldFail = false;

  final List<Categories> sampleCategories = [
    Categories(id: 1, name: 'عقارات', image: 'img1.jpg'),
    Categories(id: 2, name: 'عربيات', image: 'img2.jpg',
        subCategories: [SubCategories(id: 11, name: 'ملاكي', productsCount: 5)]),
    Categories(id: 3, name: 'موبايلات', image: 'img3.jpg'),
  ];

  AllCategoriesModel _build() => AllCategoriesModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'categories': sampleCategories
              .map((c) => c.toJson())
              .toList(),
        },
      });

  @override
  Future<Either<Failure, AllCategoriesModel>> getAllCategories() async {
    calls++;
    await Future<void>.delayed(const Duration(milliseconds: 40));
    if (shouldFail) {
      return Left(ServerFailure('fetch failed'));
    }
    return Right(_build());
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // The cubit keeps a static session-wide cache — reset it per test.
    AllCategoriesCubit.cachedModel = null;
  });

  test('initial state is AllCategoriesInitState', () {
    final cubit = AllCategoriesCubit(FakeAllCategoriesRepo());
    expect(cubit.state, isA<AllCategoriesInitState>());
    cubit.close();
  });

  test('fetch success populates the list, caches and emits Success', () async {
    final repo = FakeAllCategoriesRepo();
    final cubit = AllCategoriesCubit(repo);

    await cubit.getAllCategories();

    expect(repo.calls, 1);
    expect(cubit.state, isA<GetAllCategoriesSuccess>());
    expect(cubit.allCategoriesList.length, 3);
    expect(AllCategoriesCubit.cachedModel, isNotNull);
    expect(AllCategoriesCubit.cachedModel!.data!.categories!.length, 3);
    await cubit.close();
  });

  test('second fetch is served from cache — no extra network call', () async {
    final repo = FakeAllCategoriesRepo();
    final first = AllCategoriesCubit(repo);
    await first.getAllCategories();
    await first.close();

    final second = AllCategoriesCubit(repo);
    await second.getAllCategories();

    expect(repo.calls, 1); // served from cache
    expect(second.allCategoriesList.length, 3);
    expect(second.state, isA<GetAllCategoriesSuccess>());
    await second.close();
  });

  test('forceRefresh bypasses the cache and refetches', () async {
    final repo = FakeAllCategoriesRepo();
    final first = AllCategoriesCubit(repo);
    await first.getAllCategories();
    await first.close();

    final second = AllCategoriesCubit(repo);
    await second.getAllCategories(forceRefresh: true);

    expect(repo.calls, 2);
    await second.close();
  });

  test('failure emits GetAllCategoriesError', () async {
    final repo = FakeAllCategoriesRepo()..shouldFail = true;
    final cubit = AllCategoriesCubit(repo);

    await cubit.getAllCategories();

    expect(cubit.state, isA<GetAllCategoriesError>());
    expect(cubit.allCategoriesList, isEmpty);
    await cubit.close();
  });

  test('concurrent calls share a single in-flight request', () async {
    final repo = FakeAllCategoriesRepo();
    final cubit = AllCategoriesCubit(repo);

    final a = cubit.getAllCategories();
    final b = cubit.getAllCategories();
    await Future.wait([a, b]);

    expect(repo.calls, 1); // joined the in-flight request
    expect(cubit.state, isA<GetAllCategoriesSuccess>());
    await cubit.close();
  });
}
