import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/allSubCategoriesProducts/data/models/all_sub_categories_products_model.dart';
import 'package:by3ly/features/allSubCategoriesProducts/data/repos/all_sub_categories_products_repos.dart';
import 'package:by3ly/features/allSubCategoriesProducts/presentation/view_model/all_sub_categories_products_cubit.dart';
import 'package:by3ly/features/allSubCategoriesProducts/presentation/view_model/all_sub_categories_products_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory fake repo with configurable outcome and call counting.
class FakeAllSubCategoriesProductsRepos
    implements AllSubCategoriesProductsRepos {
  int calls = 0;
  bool shouldFail = false;

  static final _products = <Products>[
    Products(id: 1, name: 'آيفون', price: '15000', subCategoryId: 11),
    Products(id: 2, name: 'سامسونج', price: '8000', subCategoryId: 11),
  ];

  AllSubCategoriesProductsModel _build() =>
      AllSubCategoriesProductsModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'products': _products.map((p) => p.toJson()).toList(),
        },
      });

  @override
  Future<Either<Failure, AllSubCategoriesProductsModel>>
      getAllSubCategoriesProductsData({required int subCategoryId}) async {
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

  test('initial state is AllSubCategoriesProductsInitState', () {
    final cubit = AllSubCategoriesProductsCubit(
      FakeAllSubCategoriesProductsRepos(),
    );
    expect(cubit.state, isA<AllSubCategoriesProductsInitState>());
    cubit.close();
  });

  test('fetch success populates the list and emits Success', () async {
    final repo = FakeAllSubCategoriesProductsRepos();
    final cubit = AllSubCategoriesProductsCubit(repo);

    await cubit.getAllSubCategoriesProducts(subCategoryId: 11);

    expect(repo.calls, 1);
    expect(cubit.state, isA<GetAllSubCategoriesProductsSuccess>());
    expect(cubit.allSubCategoriesProductsList.length, 2);
    expect(cubit.allSubCategoriesProductsList.first.name, 'آيفون');
    await cubit.close();
  });

  test('refetch replaces the list — never duplicates items', () async {
    final repo = FakeAllSubCategoriesProductsRepos();
    final cubit = AllSubCategoriesProductsCubit(repo);

    await cubit.getAllSubCategoriesProducts(subCategoryId: 11);
    await cubit.getAllSubCategoriesProducts(subCategoryId: 11);

    expect(repo.calls, 2);
    expect(cubit.allSubCategoriesProductsList.length, 2);
    await cubit.close();
  });

  test('failure emits GetAllSubCategoriesProductsError', () async {
    final repo = FakeAllSubCategoriesProductsRepos()..shouldFail = true;
    final cubit = AllSubCategoriesProductsCubit(repo);

    await cubit.getAllSubCategoriesProducts(subCategoryId: 11);

    expect(cubit.state, isA<GetAllSubCategoriesProductsError>());
    expect(cubit.allSubCategoriesProductsList, isEmpty);
    await cubit.close();
  });
}
