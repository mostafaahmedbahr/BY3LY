import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/allSubCategoriesProducts/data/models/all_sub_categories_products_model.dart';
import 'package:by3ly/features/allSubCategoriesProducts/data/repos/all_sub_categories_products_repos.dart';
import 'package:by3ly/features/allSubCategoriesProducts/presentation/view_model/all_sub_categories_products_cubit.dart';
import 'package:by3ly/features/allSubCategoriesProducts/presentation/view_model/all_sub_categories_products_states.dart';
import 'package:by3ly/features/allSubCategoriesProducts/presentation/views/all_sub_categories_products_widgets/products_filter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory fake repo with configurable outcome, pagination and call counting.
class FakeAllSubCategoriesProductsRepos
    implements AllSubCategoriesProductsRepos {
  int calls = 0;
  bool shouldFail = false;

  /// When set, the fake emulates a backend that paginates its response.
  Pagination? pagination;

  /// Extra generated products, used to exercise the local pagination fallback.
  int extraProducts = 0;

  int lastRequestedPage = 0;
  int lastRequestedPerPage = 0;
  ProductsFilter? lastFilter;

  static final _products = <Products>[
    Products(id: 1, name: 'آيفون', price: '15000', subCategoryId: 11),
    Products(id: 2, name: 'سامسونج', price: '8000', subCategoryId: 11),
  ];

  @override
  Future<Either<Failure, AllSubCategoriesProductsModel>>
  getAllSubCategoriesProductsData({
    required int subCategoryId,
    int page = 1,
    int perPage = 10,
    ProductsFilter? filter,
  }) async {
    calls++;
    lastRequestedPage = page;
    lastRequestedPerPage = perPage;
    lastFilter = filter;
    await Future<void>.delayed(const Duration(milliseconds: 40));
    if (shouldFail) {
      return Left(ServerFailure('fetch failed'));
    }

    final all = _products.map((p) => Products.fromJson(p.toJson())).toList();
    for (int i = 0; i < extraProducts; i++) {
      all.add(Products(id: 3 + i, name: 'extra $i'));
    }
    final effectivePerPage = pagination?.perPage ?? perPage;
    final start = (page - 1) * effectivePerPage;
    final pageProducts = pagination == null
        ? all
        : (start >= all.length
              ? <Products>[]
              : all.skip(start).take(effectivePerPage).toList());
    final responsePagination = pagination == null
        ? null
        : Pagination(
            currentPage: page,
            lastPage: pagination!.lastPage,
            totalPages: pagination!.totalPages,
            perPage: pagination!.perPage,
            total: pagination!.total,
          );

    return Right(
      AllSubCategoriesProductsModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'products': pageProducts.map((p) => p.toJson()).toList(),
          if (responsePagination != null)
            'pagination': responsePagination.toJson(),
        },
      }),
    );
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

  test('server pagination appends pages and stops at the last page', () async {
    final repo = FakeAllSubCategoriesProductsRepos()
      ..extraProducts = 1
      ..pagination = Pagination(
        currentPage: 1,
        lastPage: 2,
        perPage: 2,
        total: 3,
      );
    final cubit = AllSubCategoriesProductsCubit(repo);

    await cubit.getAllSubCategoriesProducts(subCategoryId: 11);
    expect(repo.lastRequestedPage, 1);
    expect(cubit.allSubCategoriesProductsList.map((p) => p.id), [1, 2]);
    expect(cubit.lastPage, 2);
    expect(cubit.hasMore, isTrue);

    await cubit.loadMore();
    expect(repo.lastRequestedPage, 2);
    expect(cubit.allSubCategoriesProductsList.map((p) => p.id), [1, 2, 3]);
    expect(cubit.hasMore, isFalse);

    await cubit.loadMore();
    expect(repo.calls, 2);
    await cubit.close();
  });

  test('total_pages from the API enables loadMore', () async {
    final repo = FakeAllSubCategoriesProductsRepos()
      ..extraProducts = 1
      ..pagination = Pagination(
        currentPage: 1,
        totalPages: 2,
        perPage: 2,
        total: 3,
      );
    final cubit = AllSubCategoriesProductsCubit(repo);

    await cubit.getAllSubCategoriesProducts(subCategoryId: 11);
    expect(cubit.lastPage, 2);
    expect(cubit.hasMore, isTrue);

    await cubit.loadMore();
    expect(cubit.allSubCategoriesProductsList.length, 3);
    expect(cubit.hasMore, isFalse);
    await cubit.close();
  });

  test('load-more failure keeps loaded products and emits pagination error',
      () async {
    final repo = FakeAllSubCategoriesProductsRepos()
      ..pagination = Pagination(
        currentPage: 1,
        lastPage: 2,
        perPage: 2,
        total: 3,
      );
    final cubit = AllSubCategoriesProductsCubit(repo);
    await cubit.getAllSubCategoriesProducts(subCategoryId: 11);

    repo.shouldFail = true;
    await cubit.loadMore();

    expect(
      cubit.state,
      isA<GetAllSubCategoriesProductsPaginationError>(),
    );
    expect(cubit.allSubCategoriesProductsList.map((p) => p.id), [1, 2]);
    expect(cubit.isLoadingMore, isFalse);
    await cubit.close();
  });

  test('backend without pagination info is paginated locally', () async {
    final repo = FakeAllSubCategoriesProductsRepos()..extraProducts = 12;
    final cubit = AllSubCategoriesProductsCubit(repo);

    await cubit.getAllSubCategoriesProducts(subCategoryId: 11);
    expect(repo.lastRequestedPerPage, 10);
    expect(cubit.allSubCategoriesProductsList.length, 10);
    expect(cubit.lastPage, 2);
    expect(cubit.hasMore, isTrue);

    await cubit.loadMore();
    expect(cubit.allSubCategoriesProductsList.length, 14);
    expect(cubit.currentPage, 2);
    expect(cubit.hasMore, isFalse);
    await cubit.close();
  });

  test('applying a filter refetches page 1 with the filter params', () async {
    final repo = FakeAllSubCategoriesProductsRepos();
    final cubit = AllSubCategoriesProductsCubit(repo);
    await cubit.getAllSubCategoriesProducts(subCategoryId: 11);

    final filter = ProductsFilter.empty().copyWith(categoryId: 5);
    cubit.applyFilter(filter);
    await Future<void>.delayed(const Duration(milliseconds: 60));

    expect(repo.calls, 2);
    expect(repo.lastRequestedPage, 1);
    expect(repo.lastFilter?.categoryId, 5);
    expect(cubit.state, isA<GetAllSubCategoriesProductsSuccess>());
    await cubit.close();
  });
}
