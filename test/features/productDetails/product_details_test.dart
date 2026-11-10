import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
import 'package:by3ly/features/productDetails/data/models/add_product_to_compare_model.dart';
import 'package:by3ly/features/productDetails/data/models/pause_resume_ad_model.dart';
import 'package:by3ly/features/productDetails/data/models/product_details_model.dart';
import 'package:by3ly/features/productDetails/data/repos/product_details_repo.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_cubit.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_states.dart';
import 'package:by3ly/core/shared_widgets/product_badges.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

final Map<String, dynamic> _fixture = {
  'status': true,
  'message': 'ok',
  'data': {
    'product': {
      'id': '41',
      'name': 'آيفون 15 برو ماكس',
      'desc': 'وصف الإعلان',
      'price': '45000',
      'image': 'p1.jpg',
      'status': '3',
      'is_urgent': '1',
      'isFavourite': false,
      'rate': 5,
      'reviews_count': '12',
      'views': '230',
      'created_at': '2026-02-01 12:00:00',
      'location': 'القاهرة',
      'type': 'هاتف',
      'model': 'Pro Max',
      'seller': {
        'id': '7',
        'name': 'أحمد محمود',
        'image': 's.png',
        'rating': '4',
        'reviews_count': '120',
      },
      'images': [
        {'id': '91', 'image': 'a.jpg'},
        {'id': '92', 'image': 'b.jpg'},
      ],
      'safety_tips': ['احذر النصب', 'الدفع عند الاستلام'],
    },
    'relatedProducts': [
      {'id': 51, 'name': 'قريب 1', 'price': '1000', 'image': 'r1.jpg'},
    ],
    'banners': [
      {'id': '5', 'image': 'ad.png', 'title': 'sponsored'},
    ],
  },
};

class FakeProductDetailsRepo implements ProductDetailsRepo {
  int calls = 0;
  bool shouldFail = false;

  @override
  Future<Either<Failure, ProductDetailsModel>> getProductDetailsData({
    required int productId,
    required String type,
  }) async {
    calls++;
    if (shouldFail) {
      return Left(ServerFailure('fetch failed'));
    }
    return Right(ProductDetailsModel.fromJson(
      Map<String, dynamic>.from(_fixture),
    ));
  }

  @override
  Future<Either<Failure, AddProductToCompareModel>> addProductToCompare(
          {required int productId}) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, GeneralModel>> rateProduct({
    required int productId,
    required int rate,
    required String commenet,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, PauseAdResumeAdModel>> pauseAd(
          {required int adId}) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, PauseAdResumeAdModel>> resumeAd(
          {required int adId}) async =>
      throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductDetailsModel parsing', () {
    test('envelope and nested product parse with type coercion', () {
      final model = ProductDetailsModel.fromJson(_fixture);
      expect(model.status, isTrue);
      final product = model.data!.product!;
      expect(product.id, 41);
      expect(product.name, 'آيفون 15 برو ماكس');
      expect(product.status, 3);
      expect(product.isUrgent, isTrue);
      expect(product.views, 230);
      expect(product.seller!.id, 7);
      expect(product.seller!.rating, 4);
      expect(product.images!.length, 2);
      expect(model.data!.relatedProducts!.single.id, 51);
      expect(product.safetyTips, ['احذر النصب', 'الدفع عند الاستلام']);
    });

    test('non-map data is tolerated, not thrown', () {
      final model = ProductDetailsModel.fromJson({
        'status': '1',
        'data': 'nope',
      });
      expect(model.status, isTrue);
      expect(model.data, isNull);
    });

    test('garbage images entry is skipped rather than crashing', () {
      final json = Map<String, dynamic>.from(_fixture);
      final product =
          Map<String, dynamic>.from((json['data'] as Map)['product'] as Map);
      product['images'] = [
        'garbage',
        {'id': '3', 'image': 'ok.jpg'},
      ];
      (json['data'] as Map)['product'] = product;
      expect(ProductDetailsModel.fromJson(json).data!.product!.images,
          hasLength(1));
    });
  });

  group('ProductDetailsCubit', () {
    test('initial state and toggleBetweenImages', () async {
      final cubit = ProductDetailsCubit(FakeProductDetailsRepo());
      expect(cubit.state, isA<ProductDetailsInitState>());
      expect(cubit.imageIndex, 0);

      final events = <ProductDetailsStates>[];
      final sub = cubit.stream.listen(events.add);
      cubit.toggleBetweenImages(2);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.imageIndex, 2);
      expect(events.single, isA<ProductDetailsToggleBetweenImageState>());
      await sub.cancel();
      await cubit.close();
    });

    test('success emits Loading then Success and fills the model',
        () async {
      final repo = FakeProductDetailsRepo();
      final cubit = ProductDetailsCubit(repo);
      final events = <ProductDetailsStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getProductDetailsData(productId: 41, type: 'home');
      await Future<void>.delayed(Duration.zero);

      expect(repo.calls, 1);
      expect(events.first, isA<GetProductDetailsDataLoadingState>());
      expect(events.last, isA<GetProductDetailsDataSuccessState>());
      expect(cubit.productDetailsModel?.data?.product?.id, 41);
      await sub.cancel();
      await cubit.close();
    });

    test('failure emits Loading then Error', () async {
      final repo = FakeProductDetailsRepo()..shouldFail = true;
      final cubit = ProductDetailsCubit(repo);
      final events = <ProductDetailsStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getProductDetailsData(productId: 41, type: 'home');
      await Future<void>.delayed(Duration.zero);

      expect(events.first, isA<GetProductDetailsDataLoadingState>());
      expect(events.last, isA<GetProductDetailsDataErrorState>());
      expect(cubit.productDetailsModel, isNull);
      await sub.cancel();
      await cubit.close();
    });
  });

  group('isFeatured', () {
    test('accepts int and stringy featured values', () {
      expect(isFeatured(3), isTrue);
      expect(isFeatured('3'), isTrue);
      expect(isFeatured(1), isFalse);
      expect(isFeatured(null), isFalse);
    });
  });
}
