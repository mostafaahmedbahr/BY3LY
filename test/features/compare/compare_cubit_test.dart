import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
import 'package:by3ly/features/compare/data/models/compare_model.dart';
import 'package:by3ly/features/compare/data/repos/compare_repos.dart';
import 'package:by3ly/features/compare/presentation/view_model/compare_cubit.dart';
import 'package:by3ly/features/compare/presentation/view_model/compare_states.dart';
import 'package:by3ly/features/productDetails/data/models/add_product_to_compare_model.dart';
import 'package:by3ly/features/productDetails/data/models/pause_resume_ad_model.dart';
import 'package:by3ly/features/productDetails/data/models/product_details_model.dart' as details;
import 'package:by3ly/features/productDetails/data/repos/product_details_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCompareRepos implements CompareRepos {
  int calls = 0;
  bool shouldFail = false;

  final List<List<int>> payloads = [];

  @override
  Future<Either<Failure, CompareModel>> compareProducts({
    required List<int> productIds,
  }) async {
    calls++;
    payloads.add(productIds);
    if (shouldFail) return Left(ServerFailure('offline'));
    return Right(CompareModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': {
        'products': [
          {'id': productIds[0], 'name': 'Product A', 'price': '1000', 'image': 'img_a.jpg'},
          {'id': productIds[1], 'name': 'Product B', 'price': '2000', 'image': 'img_b.jpg'},
        ],
      },
    }));
  }
}

class FakeProductDetailsRepo implements ProductDetailsRepo {
  int calls = 0;

  @override
  Future<Either<Failure, details.ProductDetailsModel>> getProductDetailsData({
    required int productId,
    required String type,
  }) async {
    calls++;
    return Right(details.ProductDetailsModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': {
        'product': {
          'id': productId,
          'name': 'Fallback Product $productId',
          'desc': 'Description of product $productId',
          'price': productId == 11 ? '1000' : '2000',
          'image': 'fallback_$productId.jpg',
          'rate': 4,
          'reviews_count': 12,
          'type': 'home',
          'model': 'X$productId',
          'marka': 'BrandX',
          'location': 'Cairo',
        },
      },
    }));
  }

  @override
  Future<Either<Failure, AddProductToCompareModel>> addProductToCompare({
    required int productId,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, GeneralModel>> rateProduct({
    required int productId,
    required int rate,
    required String commenet,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, PauseAdResumeAdModel>> pauseAd({
    required int adId,
  }) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, PauseAdResumeAdModel>> resumeAd({
    required int adId,
  }) =>
      throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Basket management', () {
    late CompareCubit cubit;
    setUp(() => cubit = CompareCubit(FakeCompareRepos()));

    test('toggleBasket adds/removes a product', () {
      expect(cubit.toggleBasket(10), isTrue);
      expect(cubit.basketIds, [10]);

      expect(cubit.toggleBasket(20), isTrue);
      expect(cubit.basketIds, [10, 20]);

      expect(cubit.toggleBasket(10), isFalse);
      expect(cubit.basketIds, [20]);
    });

    test('max 2 products; third evicts the oldest', () {
      cubit.toggleBasket(10);
      cubit.toggleBasket(20);
      cubit.toggleBasket(30); // triggers eviction
      expect(cubit.basketIds, [20, 30]);
    });

    test('toggleBasket returns true when added, false when removed', () {
      expect(cubit.toggleBasket(5), isTrue);
      expect(cubit.isInBasket(5), isTrue);
      expect(cubit.toggleBasket(5), isFalse);
      expect(cubit.isInBasket(5), isFalse);
    });

    test('removeFromBasket removes only one product', () {
      cubit.toggleBasket(10);
      cubit.toggleBasket(20);
      cubit.removeFromBasket(10);
      expect(cubit.basketIds, [20]);
    });

    test('clearBasket empties basket and clears model', () {
      cubit.toggleBasket(10);
      cubit.toggleBasket(20);
      cubit.clearBasket();
      expect(cubit.basketIds, isEmpty);
      expect(cubit.compareModel, isNull);
    });
  });

  group('fetchComparison', () {
    test('does nothing when basket < 2', () async {
      final repo = FakeCompareRepos();
      final cubit = CompareCubit(repo);
      await cubit.fetchComparison();
      expect(repo.calls, 0);
      expect(cubit.state, isA<CompareInitState>());
    });

    test('success emits CompareProductsSuccess with payload', () async {
      final repo = FakeCompareRepos();
      final cubit = CompareCubit(repo, FakeProductDetailsRepo());
      cubit.toggleBasket(1);
      cubit.toggleBasket(2);

      await cubit.fetchComparison();

      expect(repo.calls, 1);
      expect(repo.payloads, [[1, 2]]);
      expect(cubit.state, isA<CompareProductsSuccess>());
      final success = cubit.state as CompareProductsSuccess;
      expect(success.compareModel.data!.products!.length, 2);
      expect(success.compareModel.data!.products![0].id, 1);
    });

    test('server failure falls back to details fallback', () async {
      final compareRepo = FakeCompareRepos()..shouldFail = true;
      final detailsRepo = FakeProductDetailsRepo();
      final cubit = CompareCubit(compareRepo, detailsRepo);
      cubit.toggleBasket(11);
      cubit.toggleBasket(12);

      await cubit.fetchComparison();

      expect(compareRepo.calls, 1);
      expect(detailsRepo.calls, 2);
      expect(cubit.state, isA<CompareProductsSuccess>());
      final model = cubit.compareModel!;
      expect(model.data!.products!.length, 2);
      expect(model.data!.products![0].name, 'Fallback Product 11');
    });

    test('no details repo emits CompareProductsError', () async {
      final compareRepo = FakeCompareRepos()..shouldFail = true;
      final cubit = CompareCubit(compareRepo); // no details repo provided
      cubit.toggleBasket(11);
      cubit.toggleBasket(12);

      await cubit.fetchComparison();

      expect(cubit.state, isA<CompareProductsError>());
      expect(cubit.compareModel, isNull);
    });
  });
}
