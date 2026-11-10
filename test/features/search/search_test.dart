import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
import 'package:by3ly/features/fav/data/models/fav_model.dart';
import 'package:by3ly/features/fav/data/repos/fav_repos.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/features/search/data/models/all_products_search_model.dart';
import 'package:by3ly/features/search/data/repos/search_repos.dart';
import 'package:by3ly/features/search/presentation/view_model/search_cubit.dart';
import 'package:by3ly/features/search/presentation/view_model/search_states.dart';
import 'package:by3ly/features/search/presentation/views/search_widgets/search_view_body.dart';
import 'package:by3ly/features/allSubCategoriesProducts/presentation/views/all_sub_categories_products_widgets/products_filter.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, dynamic> _searchJsonPage1 = {
  'status': 'true', // stringy
  'message': 'ok',
  'data': {
    'products': [
      {
        'id': 11,
        'name': 'آيفون 15 برو',
        'desc': 'وصف',
        'price': '25000',
        'image': 'p1.jpg',
        'status': 3,
        'is_urgent': true,
        'type': 'هاتف',
        'views': '10',
        'created_at': '2026-02-01',
      },
      {
        'id': 12,
        'name': 'سامسونج S24',
        'price': '18000',
        'image': 'p2.jpg',
        'status': 1,
        'is_urgent': false,
        'type': 'هاتف',
        'views': 5,
      },
    ],
    'pagination': {
      'current_page': 1,
      'last_page': 2,
      'per_page': 2,
      'total': 3,
    },
  },
};

final Map<String, dynamic> _searchJsonPage2 = {
  'status': true,
  'message': 'ok',
  'data': {
    'products': [
      {
        'id': 13,
        'name': 'اوبو Reno 12',
        'price': '15000',
        'image': 'p3.jpg',
        'status': 1,
        'type': 'هاتف',
      },
    ],
    'pagination': {
      'current_page': 2,
      'last_page': 2,
      'per_page': 2,
      'total': 3,
    },
  },
};

class FakeSearchRepos implements SearchRepos {
  int calls = 0;
  ProductsFilter? lastFilter;
  bool shouldFail = false;
  final Map<int, bool> pageFailed = {};

  @override
  Future<Either<Failure, AllProductsSearchModel>> getAllProductsForSearch({
    int page = 1,
    ProductsFilter? filter,
  }) async {
    calls++;
    lastFilter = filter;
    if (shouldFail || pageFailed[page] == true) {
      return Left(ServerFailure('fetch failed'));
    }
    final fixture =
        page == 1 ? _searchJsonPage1 : _searchJsonPage2;
    return Right(AllProductsSearchModel.fromJson(
      Map<String, dynamic>.from(fixture),
    ));
  }
}

class FakeFavRepos implements FavRepos {
  @override
  Future<Either<Failure, FavDataModel>> getFavData() async =>
      Right(FavDataModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {'favourites': const []},
      }));

  @override
  Future<Either<Failure, GeneralModel>> addProductToFav(
          {required int productId}) async =>
      Right(GeneralModel(status: true));

  @override
  Future<Either<Failure, GeneralModel>> removeProductFromFav(
          {required int productId}) async =>
      Right(GeneralModel(status: true));
}

Widget _harness({
  required Widget child,
  List<BlocProvider> providers = const [],
}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, _) => EasyLocalization(
      startLocale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: Builder(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<FavCubit>(
              create: (_) => FavCubit(FakeFavRepos())..getFavData(),
            ),
            ...providers,
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: Scaffold(body: child),
          ),
        ),
      ),
    ),
  );
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'isGuest': false});
    await CacheHelper.init();
  });

  group('AllProductsSearchModel parsing', () {
    test('parses envelope, products and pagination with coercion', () {
      final model = AllProductsSearchModel.fromJson(_searchJsonPage1);
      expect(model.status, isTrue);

      final products = model.data!.products!;
      expect(products.length, 2);
      expect(products[0].id, 11);
      expect(products[0].views, 10);
      expect(products[0].isUrgent, isTrue);
      expect(products[0].type, 'هاتف');

      final pagination = model.data!.pagination!;
      expect(pagination.currentPage, 1);
      expect(pagination.lastPage, 2);
      expect(pagination.total, 3);
    });

    test('skips garbage product entries and drops non-map data', () {
      final model = AllProductsSearchModel.fromJson({
        'status': '1',
        'message': 'ok',
        'data': {
          'products': [
            {'id': 7, 'name': 'ok'},
            'garbage',
          ],
          'pagination': 'n/a',
        },
      });
      expect(model.status, isTrue);
      expect(model.data!.products, hasLength(1));
      expect(model.data!.pagination, isNull);

      final broken = AllProductsSearchModel.fromJson(
          {'status': true, 'data': 'nope'});
      expect(broken.data, isNull);
    });
  });

  group('SearchCubit', () {
    test('initial state and filter bookkeeping', () {
      final cubit = SearchCubit(FakeSearchRepos());
      expect(cubit.state, isA<SearchInitState>());
      expect(cubit.currentPage, 1);
      expect(cubit.hasMore, isFalse);
      expect(cubit.searchFilter.isEmpty, isTrue);
      cubit.close();
    });

    test('first page loads and pagination flags are honoured', () async {
      final repo = FakeSearchRepos();
      final cubit = SearchCubit(repo);
      final events = <SearchStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getAllProductsForSearch();
      await Future<void>.delayed(Duration.zero);

      expect(repo.calls, 1);
      expect(cubit.allProductsForSearchList.length, 2);
      expect(cubit.currentPage, 1);
      expect(cubit.lastPage, 2);
      expect(cubit.hasMore, isTrue);
      expect(events.first, isA<GetAllProductsForSearchLoading>());
      expect(events.last, isA<GetAllProductsForSearchSuccess>());
      await sub.cancel();
      await cubit.close();
    });

    test('loadMore appends the next page instead of replacing', () async {
      final repo = FakeSearchRepos();
      final cubit = SearchCubit(repo);
      await cubit.getAllProductsForSearch();
      await cubit.getAllProductsForSearch(loadMore: true);

      expect(repo.calls, 2);
      expect(cubit.allProductsForSearchList.length, 3);
      expect(cubit.allProductsForSearchList[2].id, 13);
      expect(cubit.hasMore, isFalse);
      await cubit.close();
    });

    test('page-1 failure emits Error; list stays empty', () async {
      final repo = FakeSearchRepos()..shouldFail = true;
      final cubit = SearchCubit(repo);
      final events = <SearchStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getAllProductsForSearch();
      await Future<void>.delayed(Duration.zero);

      expect((events.last as GetAllProductsForSearchError).message,
          'fetch failed');
      expect(cubit.allProductsForSearchList, isEmpty);
      await sub.cancel();
      await cubit.close();
    });

    test('loadMore failure keeps the loaded page and signals pagination error',
        () async {
      final repo = FakeSearchRepos()
        ..pageFailed[2] = true;
      final cubit = SearchCubit(repo);
      final events = <SearchStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getAllProductsForSearch();
      await cubit.getAllProductsForSearch(loadMore: true);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.allProductsForSearchList.length, 2);
      expect(events.last, isA<GetAllProductsForSearchPaginationError>());
      await sub.cancel();
      await cubit.close();
    });

    test('applySearchFilter refetches with filter; clearSearchFilter resets', () async {
      final repo = FakeSearchRepos();
      final cubit = SearchCubit(repo);

      cubit.applySearchFilter(const ProductsFilter(type: 'هاتف'));
      await Future<void>.delayed(Duration.zero);

      expect(repo.calls, 1);
      expect(repo.lastFilter?.type, 'هاتف');
      expect(cubit.searchFilter.isEmpty, isFalse);

      cubit.clearSearchFilter();
      await Future<void>.delayed(Duration.zero);

      expect(repo.calls, 2);
      expect(repo.lastFilter?.type, isNull);
      expect(cubit.searchFilter.isEmpty, isTrue);
      await cubit.close();
    });
  });

  group('Search widgets', () {
    Future<SearchCubit> loadedCubit() async {
      final repo = FakeSearchRepos();
      final cubit = SearchCubit(repo);
      await cubit.getAllProductsForSearch();
      return cubit;
    }

    testWidgets('shows results and the counter', (tester) async {
      tester.view.physicalSize = const Size(390, 1500);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final cubit = await loadedCubit();
      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<SearchCubit>.value(value: cubit)],
          child: const SearchViewBody(),
        ),
      );
      await _settle(tester);

      expect(find.text('آيفون 15 برو'), findsOneWidget);
      expect(find.text('سامسونج S24'), findsOneWidget);
      expect(find.textContaining('المنتجات المعروضه'), findsOneWidget);
    });

    testWidgets('typing a query filters the visible products locally',
        (tester) async {
      tester.view.physicalSize = const Size(390, 1500);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final cubit = await loadedCubit();
      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<SearchCubit>.value(value: cubit)],
          child: const SearchViewBody(),
        ),
      );
      await _settle(tester);

      await tester.enterText(find.byType(EditableText).first, 'سامسونج');
      await _settle(tester);

      expect(find.text('سامسونج S24'), findsOneWidget);
      expect(find.text('آيفون 15 برو'), findsNothing);
    });

    testWidgets('empty results show the no-results hint', (tester) async {
      tester.view.physicalSize = const Size(390, 1500);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final cubit = await loadedCubit();
      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<SearchCubit>.value(value: cubit)],
          child: const SearchViewBody(),
        ),
      );
      await _settle(tester);

      await tester.enterText(find.byType(EditableText).first, 'zzz');
      await _settle(tester);

      expect(find.text('لا توجد نتائج، جرّب تغيير البحث أو الفلاتر'),
          findsOneWidget);
    });

    testWidgets('active filter renders a removable chip that clears the filter',
        (tester) async {
      tester.view.physicalSize = const Size(390, 1500);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final repo = FakeSearchRepos();
      final cubit = SearchCubit(repo);
      cubit.applySearchFilter(const ProductsFilter(type: 'هاتف'));
      await _settle(tester);

      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<SearchCubit>.value(value: cubit)],
          child: const SearchViewBody(),
        ),
      );
      await _settle(tester);

      expect(find.text('هاتف'), findsWidgets);
      expect(cubit.searchFilter.type, 'هاتف');

      // The chip's delete icon clears the filter.
      await tester.tap(find.byIcon(Icons.close).first);
      await _settle(tester);
      expect(cubit.searchFilter.isEmpty, isTrue);
    });
  });
}
