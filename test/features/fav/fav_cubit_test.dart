import 'dart:async';

import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
import 'package:by3ly/features/fav/data/models/fav_model.dart';
import 'package:by3ly/features/fav/data/repos/fav_repos.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory fake that behaves like the real favourites endpoint.
class FakeFavRepos implements FavRepos {
  FakeFavRepos({this.statusFalse = false, this.failNext = false}) {
    serverFavs.addAll([11, 22]);
  }

  int getCalls = 0;
  int addCalls = 0;
  int removeCalls = 0;
  bool statusFalse;
  bool failNext;

  final Set<int> serverFavs = {};

  @override
  Future<Either<Failure, FavDataModel>> getFavData() async {
    getCalls++;
    if (failNext) return Left(ServerFailure('offline'));
    if (statusFalse) {
      return Right(FavDataModel.fromJson({
        'status': false,
        'message': 'rejected',
      }));
    }
    final favs = serverFavs
        .map((id) => {
              'id': id,
              'name': 'Product $id',
              'price': '1000',
              'image': 'img$id.jpg',
              'isFavourite': true,
            })
        .toList();
    return Right(FavDataModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': {'favourites': favs},
    }));
  }

  @override
  Future<Either<Failure, GeneralModel>> addProductToFav({
    required int productId,
  }) async {
    addCalls++;
    if (failNext) return Left(ServerFailure('offline'));
    if (statusFalse) {
      return Right(GeneralModel(status: false, message: 'rejected'));
    }
    serverFavs.add(productId);
    return Right(GeneralModel(status: true, message: 'added'));
  }

  @override
  Future<Either<Failure, GeneralModel>> removeProductFromFav({
    required int productId,
  }) async {
    removeCalls++;
    if (failNext) return Left(ServerFailure('offline'));
    if (statusFalse) {
      return Right(GeneralModel(status: false, message: 'rejected'));
    }
    serverFavs.remove(productId);
    return Right(GeneralModel(status: true, message: 'removed'));
  }
}

void main() {
  group('FavCubit', () {
    late List<FavStates> emitted;
    late StreamSubscription<FavStates> sub;

    FavCubit start(FavCubit cubit) {
      emitted = [];
      sub = cubit.stream.listen(emitted.add);
      return cubit;
    }

    Future<void> pump() async {
      // Let Bloc's broadcast stream deliver every emitted state.
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
    }

    tearDown(() async {
      await sub.cancel();
    });

    test('getFavData success syncs favouriteIds and emits Success', () async {
      final repo = FakeFavRepos();
      final cubit = start(FavCubit(repo));

      await cubit.getFavData();
      await pump();

      expect(cubit.favouriteIds, {11, 22});
      expect(emitted.first, isA<GetFavDataLoading>());
      expect(emitted.last, isA<GetFavDataSuccess>());
    });

    test('getFavData failure emits error with message', () async {
      final repo = FakeFavRepos(failNext: true);
      final cubit = start(FavCubit(repo));

      await cubit.getFavData();
      await pump();

      expect(emitted.last, isA<GetFavDataError>());
      expect((emitted.last as GetFavDataError).message, 'offline');
      expect(cubit.state, isA<GetFavDataError>());
    });

    test('getFavData status false emits error from server', () async {
      final repo = FakeFavRepos(statusFalse: true);
      final cubit = start(FavCubit(repo));

      await cubit.getFavData();
      await pump();

      expect(emitted.last, isA<GetFavDataError>());
      expect((emitted.last as GetFavDataError).message, 'rejected');
    });

    test('toggleFavourite(new) calls add and marks it fav', () async {
      final repo = FakeFavRepos();
      final cubit = start(FavCubit(repo));
      await cubit.getFavData();
      await pump();
      emitted.clear();

      await cubit.toggleFavourite(productId: 99);
      await pump();

      expect(repo.addCalls, 1);
      expect(repo.removeCalls, 0);
      expect(cubit.isFavourite(99), isTrue);
      expect(emitted.first, isA<FavToggleOptimistic>());
      expect(emitted.any((s) => s is FavToggleSuccess), isTrue);
    });

    test('toggleFavourite(existing) calls remove and unmarks it', () async {
      final repo = FakeFavRepos();
      final cubit = start(FavCubit(repo));
      await cubit.getFavData();
      await pump();
      emitted.clear();

      await cubit.toggleFavourite(productId: 11);
      await pump();

      expect(repo.removeCalls, 1);
      expect(cubit.isFavourite(11), isFalse);
      expect(
        emitted.any((s) => s is FavToggleSuccess && !s.isNowFavourite),
        isTrue,
      );
    });

    test('failed add reverts the optimistic heart', () async {
      final repo = FakeFavRepos(failNext: true);
      final cubit = start(FavCubit(repo));

      await cubit.toggleFavourite(productId: 99);
      await pump();

      expect(cubit.isFavourite(99), isFalse);
      expect(emitted.last, isA<FavToggleError>());
    });

    test('failed remove reverts the optimistic heart', () async {
      final repo = FakeFavRepos();
      final cubit = start(FavCubit(repo));
      await cubit.getFavData();
      await pump();
      emitted.clear();

      repo.failNext = true;
      await cubit.toggleFavourite(productId: 11);
      await pump();

      expect(cubit.isFavourite(11), isTrue);
      expect(emitted.last, isA<FavToggleError>());
    });

    test('status false on add reverts too', () async {
      final repo = FakeFavRepos();
      final cubit = start(FavCubit(repo));
      await cubit.getFavData();
      await pump();
      emitted.clear();

      repo.statusFalse = true;
      await cubit.toggleFavourite(productId: 77);
      await pump();

      expect(cubit.isFavourite(77), isFalse);
      expect(emitted.last, isA<FavToggleError>());
    });

    test('addProductToFav success keeps local sync', () async {
      final repo = FakeFavRepos();
      final cubit = start(FavCubit(repo));

      await cubit.addProductToFav(productId: 55);
      await pump();

      expect(cubit.isFavourite(55), isTrue);
      expect(emitted.any((s) => s is AddProductToFavSuccess), isTrue);
    });

    test('removeProductFromFav success removes locally', () async {
      final repo = FakeFavRepos();
      final cubit = start(FavCubit(repo));
      await cubit.getFavData();
      await pump();
      emitted.clear();

      await cubit.removeProductFromFav(productId: 22);
      await pump();

      expect(cubit.isFavourite(22), isFalse);
      expect(emitted.any((s) => s is RemoveProductFromFavSuccess), isTrue);
    });

    test('removeProductFromFav failure keeps the id', () async {
      final repo = FakeFavRepos();
      final cubit = start(FavCubit(repo));
      await cubit.getFavData();

      repo.failNext = true;
      await cubit.removeProductFromFav(productId: 11);
      await pump();

      expect(cubit.isFavourite(11), isTrue);
      expect(emitted.last, isA<RemoveProductFromFavError>());
    });
  });

  group('FavDataModel parsing', () {
    test('mixed images list (strings and maps) is parsed', () {
      final model = FavDataModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'favourites': [
            {
              'id': 1,
              'name': 'P',
              'images': ['a.jpg', {'id': 1, 'image': 'b.jpg'}],
            },
          ],
        },
      });
      final images = model.data!.favourites!.single.images!;
      expect(images.map((e) => e.image), ['a.jpg', 'b.jpg']);
    });

    test('status 0/1/"true" parse correctly', () {
      expect(FavDataModel.fromJson({'status': 0}).status, isFalse);
      expect(FavDataModel.fromJson({'status': 'true'}).status, isTrue);
      expect(FavDataModel.fromJson({'status': 1}).status, isTrue);
    });

    test('envelope without data produces null data instead of crashing', () {
      expect(FavDataModel.fromJson({'status': true}).data, isNull);
    });
  });
}
