import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
import 'package:by3ly/core/shared_widgets/fav_heart_button.dart';
import 'package:by3ly/features/fav/data/models/fav_model.dart';
import 'package:by3ly/features/fav/data/repos/fav_repos.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/features/seeAllBestView/data/models/sell_all_best_view_model.dart';
import 'package:by3ly/features/seeAllBestView/data/repos/sell_all_best_view_repo.dart';
import 'package:by3ly/features/seeAllBestView/presentation/view_model/sell_all_best_view_cubit.dart';
import 'package:by3ly/features/seeAllBestView/presentation/view_model/sell_all_best_view_states.dart';
import 'package:by3ly/features/seeAllBestView/presentation/views/see_all_best_view_widgets/see_all_best_view_body_list.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, dynamic> _fixture = {
  'status': 'true', // stringy
  'message': 'ok',
  'data': {
    'products': [
      {
        'id': 21,
        'name': 'آيفون 15 برو',
        'desc': 'وصف',
        'price': '25000',
        'image': 'p1.jpg',
        'status': '3',
        'is_urgent': '1',
        'views': '220',
        'created_at': '2026-02-01',
        'type': 'هاتف',
      },
      {
        'id': 22,
        'name': 'سامسونج S24',
        'price': '18000',
        'image': 'p2.jpg',
        'status': 1,
        'is_urgent': false,
        'views': 15,
        'type': 'هاتف',
      },
      'garbage-entry',
    ],
  },
};

Map<String, dynamic> _bestViewPage(int page, List<int> ids) {
  return {
    'status': true,
    'message': 'ok',
    'data': {
      'products': [
        for (final id in ids)
          {'id': id, 'name': 'منتج $id', 'price': '100', 'status': 1},
      ],
      'pagination': {
        'total': 20,
        'per_page': 10,
        'current_page': page,
        'total_pages': 2,
      },
    },
  };
}

class FakeSellAllBestViewRepo implements SellAllBestViewRepo {
  int calls = 0;
  int lastPage = 0;
  bool shouldFail = false;

  FakeSellAllBestViewRepo({
    this.pageOneFixture,
    this.pageTwoFixture,
    this.failPage,
  });

  final Map<String, dynamic>? pageOneFixture;
  final Map<String, dynamic>? pageTwoFixture;
  final int? failPage;

  @override
  Future<Either<Failure, SellAllBestViewModel>> getAllBestViewProducts({
    int page = 1,
  }) async {
    calls++;
    lastPage = page;
    if (shouldFail) return Left(ServerFailure('fetch failed'));
    if (failPage == page) return Left(ServerFailure('page $page failed'));
    final source = page == 2
        ? (pageTwoFixture ?? _fixture)
        : (pageOneFixture ?? _fixture);
    return Right(
      SellAllBestViewModel.fromJson(Map<String, dynamic>.from(source)),
    );
  }
}

class FakeFavRepos implements FavRepos {
  @override
  Future<Either<Failure, FavDataModel>> getFavData() async => Right(
    FavDataModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': {'favourites': const []},
    }),
  );

  @override
  Future<Either<Failure, GeneralModel>> addProductToFav({
    required int productId,
  }) async => Right(GeneralModel(status: true));

  @override
  Future<Either<Failure, GeneralModel>> removeProductFromFav({
    required int productId,
  }) async => Right(GeneralModel(status: true));
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

Future<SellAllBestViewCubit> _loadedCubit() async {
  final repo = FakeSellAllBestViewRepo();
  final cubit = SellAllBestViewCubit(repo);
  await cubit.getSellAllBestView();
  return cubit;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'isGuest': false});
    await CacheHelper.init();
  });

  group('SellAllBestViewModel parsing', () {
    test('parses envelope and products, skipping garbage entries', () {
      final model = SellAllBestViewModel.fromJson(_fixture);
      expect(model.status, isTrue);
      final products = model.data!.products!;
      expect(products.length, 2);
      expect(products[0].id, 21);
      expect(products[0].views, 220);
      expect(products[0].isUrgent, isTrue);
      expect(products[0].status, 3);
    });

    test('non-map data is dropped, not thrown', () {
      final model = SellAllBestViewModel.fromJson({
        'status': true,
        'data': 'nope',
      });
      expect(model.data, isNull);
    });

    test('pagination accepts total_pages and the last_page alias', () {
      final model = SellAllBestViewModel.fromJson(_bestViewPage(1, [21]));
      expect(model.data!.pagination!.totalPages, 2);
      expect(model.data!.pagination!.currentPage, 1);

      final aliased = SellAllBestViewModel.fromJson({
        'status': true,
        'data': {
          'products': [],
          'pagination': {'current_page': 1, 'last_page': 3},
        },
      });
      expect(aliased.data!.pagination!.totalPages, 3);
    });
  });

  group('SellAllBestViewCubit', () {
    test('initial state', () {
      final cubit = SellAllBestViewCubit(FakeSellAllBestViewRepo());
      expect(cubit.state, isA<SellAllBestViewInitState>());
      cubit.close();
    });

    test('success emits Loading then Success and fills the model', () async {
      final repo = FakeSellAllBestViewRepo();
      final cubit = SellAllBestViewCubit(repo);
      final events = <SellAllBestViewStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getSellAllBestView();
      await Future<void>.delayed(Duration.zero);

      expect(repo.calls, 1);
      expect(events.first, isA<GetAllBestViewProductsLoadingState>());
      expect(events.last, isA<GetAllBestViewProductsSuccessState>());
      expect(cubit.sellAllBestViewModel?.data?.products?.length, 2);
      await sub.cancel();
      await cubit.close();
    });

    test('failure emits Loading then Error', () async {
      final repo = FakeSellAllBestViewRepo()..shouldFail = true;
      final cubit = SellAllBestViewCubit(repo);
      final events = <SellAllBestViewStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getSellAllBestView();
      await Future<void>.delayed(Duration.zero);

      expect(
        (events.last as GetAllBestViewProductsErrorState).error,
        'fetch failed',
      );
      expect(cubit.sellAllBestViewModel, isNull);
      await sub.cancel();
      await cubit.close();
    });

    test('loadMore fetches page 2 and appends without duplicates', () async {
      final repo = FakeSellAllBestViewRepo(
        pageOneFixture: _bestViewPage(1, [21]),
        pageTwoFixture: _bestViewPage(2, [21, 22]),
      );
      final cubit = SellAllBestViewCubit(repo);
      final events = <SellAllBestViewStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getSellAllBestView();
      expect(cubit.hasMore, isTrue);
      await cubit.getSellAllBestView(loadMore: true);
      await Future<void>.delayed(Duration.zero);

      expect(repo.calls, 2);
      expect(repo.lastPage, 2);
      expect(cubit.sellAllBestViewModel!.data!.products!.map((p) => p.id), [
        21,
        22,
      ]);
      expect(cubit.isLoadingMore, isFalse);
      expect(cubit.hasMore, isFalse);
      expect(events.last, isA<GetAllBestViewProductsSuccessState>());
      await sub.cancel();
      await cubit.close();
    });

    test('loadMore is ignored once the last page is reached', () async {
      final repo = FakeSellAllBestViewRepo();
      final cubit = SellAllBestViewCubit(repo);
      await cubit.getSellAllBestView();
      expect(cubit.hasMore, isFalse);

      await cubit.getSellAllBestView(loadMore: true);
      expect(repo.calls, 1);
      await cubit.close();
    });

    test('pagination error keeps earlier products on screen', () async {
      final repo = FakeSellAllBestViewRepo(
        pageOneFixture: _bestViewPage(1, [21]),
        failPage: 2,
      );
      final cubit = SellAllBestViewCubit(repo);
      final events = <SellAllBestViewStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getSellAllBestView();
      await cubit.getSellAllBestView(loadMore: true);
      await Future<void>.delayed(Duration.zero);

      expect(events.last, isA<GetAllBestViewProductsPaginationErrorState>());
      expect(cubit.sellAllBestViewModel!.data!.products!.single.id, 21);
      expect(cubit.isLoadingMore, isFalse);
      await sub.cancel();
      await cubit.close();
    });
  });

  group('Widgets', () {
    testWidgets('grid shows products with the local search filter', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final cubit = await _loadedCubit();
      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<SellAllBestViewCubit>.value(value: cubit)],
          child: const SeeAllBestViewBodyList(),
        ),
      );
      await _settle(tester);

      expect(find.text('آيفون 15 برو'), findsOneWidget);
      expect(find.text('سامسونج S24'), findsOneWidget);

      await tester.enterText(find.byType(EditableText).first, 'سامسونج');
      await _settle(tester);

      expect(find.text('سامسونج S24'), findsOneWidget);
      expect(find.text('آيفون 15 برو'), findsNothing);
    });

    testWidgets('empty search shows the localized no-results hint', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final cubit = await _loadedCubit();
      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<SellAllBestViewCubit>.value(value: cubit)],
          child: const SeeAllBestViewBodyList(),
        ),
      );
      await _settle(tester);

      await tester.enterText(find.byType(EditableText).first, 'zzz');
      await _settle(tester);

      expect(
        find.text('لا توجد نتائج، جرّب تغيير البحث أو الفلاتر'),
        findsOneWidget,
      );
    });

    testWidgets('error state renders and retry re-triggers the fetch', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final repo = FakeSellAllBestViewRepo()..shouldFail = true;
      final cubit = SellAllBestViewCubit(repo);
      await cubit.getSellAllBestView();

      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<SellAllBestViewCubit>.value(value: cubit)],
          child: const SeeAllBestViewBodyList(),
        ),
      );
      await _settle(tester);

      expect(find.text('fetch failed'), findsOneWidget);

      // Tap the retry text — repo gets called again.
      await tester.tap(find.text('fetch failed'));
      await _settle(tester);
      expect(repo.calls, 2);
    });

    testWidgets('load-more button fetches and shows the next page', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final repo = FakeSellAllBestViewRepo(
        pageOneFixture: _bestViewPage(1, [21]),
        pageTwoFixture: _bestViewPage(2, [22]),
      );
      final cubit = SellAllBestViewCubit(repo);
      await cubit.getSellAllBestView();
      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<SellAllBestViewCubit>.value(value: cubit)],
          child: const SeeAllBestViewBodyList(),
        ),
      );
      await _settle(tester);

      expect(find.text('رؤية المزيد'), findsOneWidget);
      expect(find.text('منتج 22'), findsNothing);

      await tester.tap(find.text('رؤية المزيد'));
      await _settle(tester);

      expect(repo.lastPage, 2);
      expect(find.text('منتج 22'), findsOneWidget);
      expect(find.text('رؤية المزيد'), findsNothing);
      await cubit.close();
    });

    testWidgets('typing filters after the debounce, not on every keystroke', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final cubit = await _loadedCubit();
      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<SellAllBestViewCubit>.value(value: cubit)],
          child: const SeeAllBestViewBodyList(),
        ),
      );
      await _settle(tester);

      await tester.enterText(find.byType(EditableText).first, 'سامسونج');
      await tester.pump(const Duration(milliseconds: 80));
      // Still inside the debounce window — the old result stays on screen.
      expect(find.text('آيفون 15 برو'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('سامسونج S24'), findsOneWidget);
      expect(find.text('آيفون 15 برو'), findsNothing);
      await cubit.close();
    });

    testWidgets('a heart follows a toggle started from another screen', (
      tester,
    ) async {
      final favCubit = FavCubit(FakeFavRepos())..getFavData();
      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<FavCubit>.value(value: favCubit)],
          child: const FavHeartButton(productId: 77),
        ),
      );
      await _settle(tester);

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      await favCubit.toggleFavourite(productId: 77);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      await favCubit.close();
    });
  });
}
