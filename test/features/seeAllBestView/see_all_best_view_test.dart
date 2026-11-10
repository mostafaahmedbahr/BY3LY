import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
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

class FakeSellAllBestViewRepo implements SellAllBestViewRepo {
  int calls = 0;
  bool shouldFail = false;

  @override
  Future<Either<Failure, SellAllBestViewModel>> getAllBestViewProducts() async {
    calls++;
    if (shouldFail) return Left(ServerFailure('fetch failed'));
    return Right(SellAllBestViewModel.fromJson(
      Map<String, dynamic>.from(_fixture),
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
      final model =
          SellAllBestViewModel.fromJson({'status': true, 'data': 'nope'});
      expect(model.data, isNull);
    });
  });

  group('SellAllBestViewCubit', () {
    test('initial state', () {
      final cubit = SellAllBestViewCubit(FakeSellAllBestViewRepo());
      expect(cubit.state, isA<SellAllBestViewInitState>());
      cubit.close();
    });

    test('success emits Loading then Success and fills the model',
        () async {
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

      expect((events.last as GetAllBestViewProductsErrorState).error,
          'fetch failed');
      expect(cubit.sellAllBestViewModel, isNull);
      await sub.cancel();
      await cubit.close();
    });
  });

  group('Widgets', () {
    testWidgets('grid shows products with the local search filter',
        (tester) async {
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

      await tester.enterText(
          find.byType(EditableText).first, 'سامسونج');
      await _settle(tester);

      expect(find.text('سامسونج S24'), findsOneWidget);
      expect(find.text('آيفون 15 برو'), findsNothing);
    });

    testWidgets('empty search shows the localized no-results hint',
        (tester) async {
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

      expect(find.text('لا توجد نتائج، جرّب تغيير البحث أو الفلاتر'),
          findsOneWidget);
    });

    testWidgets('error state renders and retry re-triggers the fetch',
        (tester) async {
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
  });
}
