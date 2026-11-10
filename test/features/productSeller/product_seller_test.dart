import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
import 'package:by3ly/features/chat/data/repos/chat_repository_impl.dart';
import 'package:by3ly/features/fav/data/models/fav_model.dart';
import 'package:by3ly/features/fav/data/repos/fav_repos.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/features/productSeller/data/models/product_seller_model.dart';
import 'package:by3ly/features/productSeller/data/repos/product_seller_repos.dart';
import 'package:by3ly/features/productSeller/presentation/view_model/product_seller_cubit.dart';
import 'package:by3ly/features/productSeller/presentation/view_model/product_seller_states.dart';
import 'package:by3ly/features/productSeller/presentation/views/seller_widgets/seller_hero_card.dart';
import 'package:by3ly/features/productSeller/presentation/views/seller_widgets/seller_info_panel.dart';
import 'package:by3ly/features/productSeller/presentation/views/seller_widgets/seller_products_list.dart';
import 'package:by3ly/features/productSeller/presentation/views/seller_widgets/seller_shimmer.dart';
import 'package:by3ly/features/productSeller/presentation/views/seller_widgets/seller_view_body.dart';
import 'package:by3ly/features/productSeller/presentation/views/seller_widgets/seller_tab_buttons.dart';
import 'package:by3ly/features/profile/data/models/logout_model.dart';
import 'package:by3ly/features/profile/data/models/profile_data_model.dart';
import 'package:by3ly/features/deleteAccount/data/models/delete_account_model.dart';
import 'package:by3ly/features/profile/data/repos/profile_repos.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, dynamic> _sellerJson = {
  'status': true,
  'message': 'ok',
  'data': {
    'seller': {
      // Stringy scalars — parser must coerce.
      'id': '7',
      'name': 'أحمد محمود',
      'phone': '01012345678',
      'contact_method': 'chat',
      'can_chat': true,
      'can_call': '1',
      'store_name': 'أحمد ستور',
      'image': 'seller.png',
      'rating': '4.5',
      'reviews_count': '120',
      'products_count': '34',
    },
    'products': [
      {
        'id': 21,
        'name': 'آيفون 15 برو',
        'price': '25000',
        'image': 'p1.jpg',
        'type': 'هاتف',
        'model': 'Pro',
        'location': 'القاهرة',
        'status': 3,
        'is_urgent': true,
        'views': '10',
        'created_at': '2026-01-01 10:00:00',
        'images': [
          {'id': '31', 'image': 'a.jpg'},
        ],
      },
      {
        'id': 22,
        'name': 'سامسونج S24',
        'price': '18000',
        'image': 'p2.jpg',
        'type': 'هاتف',
        'model': 'S24',
        'location': 'الجيزة',
        'status': 1,
        'is_urgent': false,
        'views': 5,
      },
    ],
    'pagination': {
      'total': 2,
      'per_page': 10,
      'current_page': '1',
      'total_pages': 1,
    },
  },
};

class FakeProductSellerRepo implements ProductSellerRepo {
  int calls = 0;
  int? lastSellerId;
  bool shouldFail = false;

  @override
  Future<Either<Failure, ProductSellerModel>> getProductSellerData({
    required int sellerId,
  }) async {
    calls++;
    lastSellerId = sellerId;
    if (shouldFail) {
      return Left(ServerFailure('fetch failed'));
    }
    // Fresh copy every call — repos must not leak fixtures between tests.
    return Right(ProductSellerModel.fromJson(
      Map<String, dynamic>.from(_sellerJson),
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
      Right(GeneralModel(status: true, message: 'added'));

  @override
  Future<Either<Failure, GeneralModel>> removeProductFromFav(
          {required int productId}) async =>
      Right(GeneralModel(status: true, message: 'removed'));
}

class FakeProfileRepos implements ProfileRepos {
  @override
  Future<Either<Failure, ProfileModel>> getProfileData() async =>
      Right(ProfileModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'user': {
            'id': 999,
            'name': 'Me',
            'wallet_balance': 0,
            'center_id': 1,
            'city_id': 1,
          },
        },
      }));

  @override
  Future<Either<Failure, LogoutModel>> logout() async =>
      Right(LogoutModel.fromJson({'status': true, 'message': 'ok'}));

  @override
  Future<Either<Failure, DeleteAccountModel>> deleteAccount() async =>
      Right(DeleteAccountModel.fromJson({'status': true, 'message': 'ok'}));
}

Widget _harness({
  List<BlocProvider> providers = const [],
  required Widget child,
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
            home: Scaffold(
              body: child,
            ),
          ),
        ),
      ),
    ),
  );
}


Future<void> _settle(WidgetTester tester) async {
  // Shimmer placeholders loop forever — pump fixed frames instead of
  // pumpAndSettle, which would never return.
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'isGuest': false});
    await CacheHelper.init();
  });

  // The foreign-profile hero CTA builds a StartChatButton whose cubit
  // resolves the chat repository straight from the service locator.
  setUp(() {
    if (!getIt.isRegistered<ChatRepositoryImpl>()) {
      getIt.registerSingleton<ChatRepositoryImpl>(ChatRepositoryImpl(null));
    }
  });

  tearDown(() async {
    if (getIt.isRegistered<ChatRepositoryImpl>()) {
      await getIt.unregister<ChatRepositoryImpl>();
    }
  });

  group('ProductSellerModel parsing', () {
    test('parses envelope, seller and products with tolerance', () {
      final model = ProductSellerModel.fromJson(_sellerJson);
      expect(model.status, isTrue);
      expect(model.message, 'ok');

      final seller = model.data!.seller!;
      expect(seller.id, 7);
      expect(seller.name, 'أحمد محمود');
      expect(seller.storeName, 'أحمد ستور');
      expect(seller.rating, 4.5);
      expect(seller.reviewsCount, 120);
      expect(seller.productsCount, 34);

      final products = model.data!.products!;
      expect(products.length, 2);
      expect(products[0].id, 21);
      expect(products[0].isUrgent, isTrue);
      expect(products[0].status, 3);
      expect(products[0].views, 10);
      expect(products[0].images!.length, 1);
      expect(products[0].images!.first.image, 'a.jpg');

      expect(model.data!.pagination!.currentPage, 1);
    });

    test('non-map data payload is dropped instead of crashing', () {
      final model = ProductSellerModel.fromJson({
        'status': '1',
        'message': 'ok',
        'data': 'not-a-map',
      });
      expect(model.status, isTrue);
      expect(model.data, isNull);
    });

    test('non-map nested seller/pagination are tolerated', () {
      final model = ProductSellerModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'seller': 123,
          'pagination': 'n/a',
          'products': [
            {'id': '41'},
            'garbage-entry',
          ],
        },
      });
      expect(model.data, isNotNull);
      expect(model.data!.seller, isNull);
      expect(model.data!.pagination, isNull);
      expect(model.data!.products!.length, 1);
      expect(model.data!.products!.single.id, 41);
    });
  });

  group('ProductSellerCubit', () {
    test('initial state is ProductSellerInitState', () {
      final cubit = ProductSellerCubit(FakeProductSellerRepo());
      expect(cubit.state, isA<ProductSellerInitState>());
      expect(cubit.state.toString(), 'ProductSellerInitState');
      expect(cubit.sellerDataIndex, 1);
      cubit.close();
    });

    test('success emits Loading then Success and fills the model',
        () async {
      final repo = FakeProductSellerRepo();
      final cubit = ProductSellerCubit(repo);
      final events = <ProductSellerStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getProductSellerData(sellerId: 7);
      await Future<void>.delayed(Duration.zero);

      expect(repo.calls, 1);
      expect(repo.lastSellerId, 7);
      expect(events[0], isA<GetProductSellerDataLoadingState>());
      expect(events.last, isA<GetProductSellerDataSuccessState>());
      expect(cubit.productSellerModel?.data?.seller?.id, 7);
      expect(cubit.productSellerModel?.data?.products?.length, 2);
      await sub.cancel();
      await cubit.close();
    });

    test('failure emits Loading then Error with the failure message',
        () async {
      final repo = FakeProductSellerRepo()..shouldFail = true;
      final cubit = ProductSellerCubit(repo);
      final events = <ProductSellerStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getProductSellerData(sellerId: 7);
      await Future<void>.delayed(Duration.zero);

      expect(events.first, isA<GetProductSellerDataLoadingState>());
      expect(events.last, isA<GetProductSellerDataErrorState>());
      expect((events.last as GetProductSellerDataErrorState).error,
          'fetch failed');
      expect(cubit.productSellerModel, isNull);
      await sub.cancel();
      await cubit.close();
    });

    test('changeSellerDataIndex updates the index and emits SellerDataIndexState',
        () async {
      final cubit = ProductSellerCubit(FakeProductSellerRepo());
      final events = <ProductSellerStates>[];
      final sub = cubit.stream.listen(events.add);

      cubit.changeSellerDataIndex(2);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.sellerDataIndex, 2);
      expect(events.single, isA<SellerDataIndexState>());
      await sub.cancel();
      await cubit.close();
    });
  });

  group('Seller widgets', () {
    testWidgets('shimmer skeleton pumps cleanly', (tester) async {
      await tester.pumpWidget(_harness(child: const SellerShimmer()));
      await tester.pump();
      expect(find.byType(SellerShimmer), findsOneWidget);
    });

    testWidgets('tabs show the three pills and switch the active tab',
        (tester) async {
      final cubit = ProductSellerCubit(FakeProductSellerRepo());
      await tester.pumpWidget(
        _harness(
          providers: [
            BlocProvider<ProductSellerCubit>.value(value: cubit),
          ],
          child: const SellerTabButtons(),
        ),
      );
      await _settle(tester);

      expect(find.text('بيانات البائع'), findsOneWidget);
      expect(find.text('المعروض الان'), findsOneWidget);
      expect(find.text('المبيعات السابقة'), findsOneWidget);
      expect(cubit.sellerDataIndex, 1);

      await tester.tap(find.text('المعروض الان'));
      await _settle(tester);
      expect(cubit.sellerDataIndex, 2);

      await tester.tap(find.text('المبيعات السابقة'));
      await _settle(tester);
      expect(cubit.sellerDataIndex, 3);

      await cubit.close();
    });

    testWidgets('products list renders items and an empty state',
        (tester) async {
      final model = ProductSellerModel.fromJson(_sellerJson);

      await tester.pumpWidget(
        _harness(child: SellerProductsList(products: model.data!.products)),
      );
      await _settle(tester);
      expect(find.text('آيفون 15 برو'), findsOneWidget);
      expect(find.text('سامسونج S24'), findsOneWidget);

      await tester.pumpWidget(
        _harness(child: const SellerProductsList(products: [])),
      );
      await _settle(tester);
      expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);

      await tester.pumpWidget(
        _harness(child: const SellerProductsList(products: null)),
      );
      await _settle(tester);
      expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
    });

    testWidgets('info panel shows seller identity and store',
        (tester) async {
      final cubit = ProductSellerCubit(FakeProductSellerRepo());
      cubit.productSellerModel =
          ProductSellerModel.fromJson(_sellerJson);

      await tester.pumpWidget(
        _harness(
          providers: [
            BlocProvider<ProductSellerCubit>.value(value: cubit),
          ],
          child: const SellerInfoPanel(),
        ),
      );
      await _settle(tester);

      expect(find.text('أحمد محمود'), findsOneWidget);
      expect(find.text('01012345678'), findsOneWidget);
      expect(find.text('أحمد ستور'), findsOneWidget);
      await cubit.close();
    });

    testWidgets('contact CTA is hidden on your own profile', (tester) async {
      final profileCubit = ProfileCubit(FakeProfileRepos());
      profileCubit.profileModel = ProfileModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'user': {
            'id': 7,
            'name': 'Ahmed',
            'wallet_balance': 0,
            'center_id': 1,
            'city_id': 1,
          },
        },
      });
      final seller =
          ProductSellerModel.fromJson(_sellerJson).data!.seller!;

      await tester.pumpWidget(
        _harness(
          providers: [
            BlocProvider<ProfileCubit>.value(value: profileCubit),
          ],
          child: SellerHeroCard(seller: seller, sellerId: 7),
        ),
      );
      await _settle(tester);

      expect(find.text('تواصل الان'), findsNothing);
      await profileCubit.close();
    });

    testWidgets('contact CTA is shown for a foreign seller',
        (tester) async {
      final profileCubit = ProfileCubit(FakeProfileRepos());
      profileCubit.profileModel = null; // signed-out / unknown
      final seller =
          ProductSellerModel.fromJson(_sellerJson).data!.seller!;

      await tester.pumpWidget(
        _harness(
          providers: [
            BlocProvider<ProfileCubit>.value(value: profileCubit),
          ],
          child: SellerHeroCard(seller: seller, sellerId: 7),
        ),
      );
      await _settle(tester);

      expect(find.text('تواصل الان'), findsOneWidget);
      await profileCubit.close();
    });
    testWidgets('body renders hero and tabs on success', (tester) async {
      await tester.pumpWidget(
        _harness(
          providers: [
            BlocProvider<ProfileCubit>(
              create: (_) => ProfileCubit(FakeProfileRepos()),
            ),
          ],
          child: ProductSellerViewBody(
            sellerId: 7,
            repo: FakeProductSellerRepo(),
          ),
        ),
      );
      await _settle(tester);

      expect(find.text('أحمد محمود'), findsWidgets);
      expect(find.text('المعروض الان'), findsOneWidget);
      await _settle(tester);
    });

    testWidgets('body shows error state and retry on failure',
        (tester) async {
      final repo = FakeProductSellerRepo()..shouldFail = true;
      await tester.pumpWidget(
        _harness(
          child: ProductSellerViewBody(sellerId: 7, repo: repo),
        ),
      );
      await _settle(tester);

      expect(find.text('fetch failed'), findsOneWidget);

      // Tapping the retry text re-triggers the fetch.
      await tester.tap(find.text('fetch failed'));
      await _settle(tester);
      expect(repo.calls, 2);
    });
  });

}
