import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/home/data/models/banners_model.dart';
import 'package:by3ly/features/home/data/models/home_model.dart';
import 'package:by3ly/features/home/data/repos/home_repo.dart';
import 'package:by3ly/features/home/presentation/view_model/home_cubit.dart';
import 'package:by3ly/features/home/presentation/view_model/home_states.dart';
import 'package:by3ly/features/home/presentation/views/home_widgets/banner_link.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeHomeRepo implements HomeRepo {
  FakeHomeRepo({
    this.homeFails = false,
    this.bannersFails = false,
    this.homePayload,
    this.bannersPayload,
  });

  final bool homeFails;
  final bool bannersFails;
  final Either<Failure, HomeModel> Function()? homePayload;
  final Either<Failure, BannersModel> Function()? bannersPayload;

  @override
  Future<Either<Failure, HomeModel>> getHomeData() async {
    if (homeFails) return Left(ServerFailure('offline'));
    if (homePayload != null) return homePayload!();
    return Right(HomeModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': {
        'categories': [
          {'id': 1, 'name': 'موبايلات', 'image': 'cat1.png'},
          {'id': 2, 'name': 'سيارات', 'image': 'cat2.png'},
        ],
        'bestView': [
          {'id': 11, 'name': 'iPhone 15', 'price': '25000', 'image': 'a.jpg'},
        ],
        'ads': [
          {'id': 91, 'name': 'Sponsored', 'image': 'ad.jpg'},
        ],
      },
    }));
  }

  @override
  Future<Either<Failure, BannersModel>> getBanners() async {
    if (bannersFails) return Left(ServerFailure('offline'));
    if (bannersPayload != null) return bannersPayload!();
    return Right(BannersModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': [
        {'id': 1, 'image': 'b1.jpg', 'title': 'عرض'},
        {'id': 2, 'image': 'b2.jpg'},
      ],
    }));
  }
}

Map<String, dynamic> _fullEnvelope() => {
      'status': true,
      'message': 'ok',
      'data': {
        'categories': [
          {'id': 1, 'name': 'سيارات', 'image': 'car.png'},
          'junk', // malformed entry must be skipped, not crash
        ],
        'bestView': [
          {'id': 11, 'name': 'iPhone', 'price': '25000'},
        ],
        'ads': [
          {
            'id': 91,
            'name': 'Sponsored',
            'price': '100',
            'image': 'ad.jpg',
            'images': ['ad1.jpg', {'id': 5, 'image': 'ad2.jpg'}, 123],
          },
        ],
      },
    };

void main() {
  group('HomeModel parsing', () {
    test('full envelope with junk entries parses', () {
      final model = HomeModel.fromJson(_fullEnvelope());
      expect(model.status, isTrue);
      expect(model.data?.categories?.length, 1);
      expect(model.data?.bestView?.single.id, 11);
      expect(model.data?.ads?.single.id, 91);
    });

    test('mixed ads images preserve strings and object entries', () {
      final model = HomeModel.fromJson(_fullEnvelope());
      final images = model.data!.ads!.single.images!;
      expect(images.map((e) => e.image).toList(), ['ad1.jpg', 'ad2.jpg']);
    });

    test('non-list images on bestView keeps model alive', () {
      final model = HomeModel.fromJson({
        'status': 1,
        'data': {
          'bestView': [
            {'id': 5, 'name': 'X', 'images': 'not-a-list'},
          ],
        },
      });
      expect(model.status, isTrue);
      expect(model.data?.bestView?.single.images, isEmpty);
    });

    test('envelope without data is null, not a crash', () {
      expect(HomeModel.fromJson({'status': true}).data, isNull);
    });
  });

  group('BannersModel parsing', () {
    test('data as bare list parses', () {
      final model = BannersModel.fromJson({
        'status': true,
        'data': [
          {'id': 1, 'image': 'b1.jpg', 'title': 'first'},
          {'id': 2, 'image': 'b2.jpg'},
        ],
      });
      expect(model.banners?.length, 2);
      expect(model.banners?.first.title, 'first');
    });

    test('data as map with banners key parses', () {
      final model = BannersModel.fromJson({
        'status': true,
        'data': {
          'banners': [
            {'id': 3, 'image_url': 'wrapped.jpg'},
          ],
        },
      });
      expect(model.banners?.single.image, 'wrapped.jpg');
    });

    test('bare string entries are accepted', () {
      final model = BannersModel.fromJson({
        'status': true,
        'data': ['a.jpg', 'b.jpg'],
      });
      expect(model.banners?.map((b) => b.image), ['a.jpg', 'b.jpg']);
    });
  });

  group('BannerLink', () {
    test('bare domain gets https:// prefix', () {
      expect(BannerLink.normalizeUrl('example.com'), 'https://example.com');
    });

    test('fully formed URLs stay untouched', () {
      expect(BannerLink.normalizeUrl('https://by3ly.com/page'),
          'https://by3ly.com/page');
      expect(BannerLink.normalizeUrl('http://by3ly.com'), 'http://by3ly.com');
    });

    test('blank/garbage input returns null', () {
      expect(BannerLink.normalizeUrl(null), isNull);
      expect(BannerLink.normalizeUrl(''), isNull);
      expect(BannerLink.normalizeUrl('   '), isNull);
    });

    test('whitespace around URL is trimmed', () {
      expect(BannerLink.normalizeUrl('  https://by3ly.com/x  '),
          'https://by3ly.com/x');
    });
  });

  group('HomeCubit', () {
    test('getHome success emits GetHomeDataSuccess and stores model', () async {
      final cubit = HomeCubit(FakeHomeRepo());
      await cubit.getHome();
      expect(cubit.state, isA<GetHomeDataSuccess>());
      expect(cubit.homeModel?.data?.bestView, isNotEmpty);
    });

    test('getHome failure emits GetHomeDataError', () async {
      final cubit = HomeCubit(FakeHomeRepo(homeFails: true));
      await cubit.getHome();
      expect(cubit.state, isA<GetHomeDataError>());
      expect((cubit.state as GetHomeDataError).message, 'offline');
    });

    test('getBanners fills banners and drops empty-image items', () async {
      final cubit = HomeCubit(FakeHomeRepo(
        bannersPayload: () => Right(BannersModel.fromJson({
          'status': true,
          'data': [
            {'id': 1, 'image': 'b1.jpg'},
            {'id': 2, 'image': ''}, // dropped by the slider getter
            {'id': 3}, // dropped too — no image at all
          ],
        })),
      ));
      await cubit.getBanners();
      expect(cubit.banners.length, 1);
      expect(cubit.banners.single.image, 'b1.jpg');
    });

    test('getBanners failure with no cached banners emits error', () async {
      final cubit = HomeCubit(FakeHomeRepo(bannersFails: true));
      await cubit.getBanners();
      expect(cubit.state, isA<GetBannersError>());
    });
  });
}
