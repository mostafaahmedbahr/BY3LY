import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
import 'package:by3ly/features/home/data/models/banners_model.dart';
import 'package:by3ly/features/home/data/models/home_model.dart';
import 'package:by3ly/features/home/data/repos/home_repo.dart';
import 'package:by3ly/features/home/presentation/view_model/home_cubit.dart';
import 'package:by3ly/features/notifications/data/models/notifications_model.dart';
import 'package:by3ly/features/notifications/data/repos/notifications_repos.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:by3ly/features/profile/data/models/logout_model.dart';
import 'package:by3ly/features/profile/data/models/profile_data_model.dart';
import 'package:by3ly/features/profile/data/repos/profile_repos.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/features/home/presentation/views/home_view.dart';
import 'package:by3ly/features/deleteAccount/data/models/delete_account_model.dart';
import 'package:by3ly/features/fav/data/models/fav_model.dart';
import 'package:by3ly/features/fav/data/repos/fav_repos.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeHomeRepo implements HomeRepo {
  @override
  Future<Either<Failure, HomeModel>> getHomeData() async {
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
          {'id': 12, 'name': 'Samsung S24', 'price': '18000', 'image': 'b.jpg'},
        ],
        'ads': [
          {'id': 91, 'name': 'Sponsored Ad', 'image': 'ad.jpg'},
        ],
      },
    }));
  }

  @override
  Future<Either<Failure, BannersModel>> getBanners() async {
    return Right(BannersModel.fromJson({
      'status': true,
      'data': [
        {'id': 1, 'image': 'b1.jpg', 'title': 'عرض'},
        {'id': 2, 'image': 'b2.jpg'},
      ],
    }));
  }
}

class FakeNotificationsRepos implements NotificationsRepos {
  @override
  Future<Either<Failure, NotificationsModel>> getNotificationsData({
    required String type,
    int page = 1,
    int perPage = 15,
  }) async {
    return Right(NotificationsModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': <String, dynamic>{},
    }));
  }

  @override
  Future<Either<Failure, GeneralModel>> markNotificationRead({
    required String notificationId,
  }) async => Right(GeneralModel(status: true));

  @override
  Future<Either<Failure, GeneralModel>> markAllNotificationsRead() async =>
      Right(GeneralModel(status: true));

  @override
  Future<Either<Failure, GeneralModel>> deleteNotification({
    required String notificationId,
  }) async => Right(GeneralModel(status: true));

  @override
  Future<Either<Failure, GeneralModel>> deleteAllNotifications() async =>
      Right(GeneralModel(status: true));
}

class FakeProfileRepos implements ProfileRepos {
  @override
  Future<Either<Failure, ProfileModel>> getProfileData() async {
    return Right(ProfileModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': {
        'user': {
          'id': 1,
          'name': 'Ahmed',
          'email': 'a@b.com',
          'phone': '01000000000',
          'cityName': 'القاهرة',
        },
      },
    }));
  }

  @override
  Future<Either<Failure, LogoutModel>> logout() async =>
      Right(LogoutModel.fromJson({'status': true, 'message': 'ok'}));

  @override
  Future<Either<Failure, DeleteAccountModel>> deleteAccount() async =>
      Right(DeleteAccountModel.fromJson({'status': true, 'message': 'ok'}));
}

class FakeFavRepos implements FavRepos {
  final Set<int> serverFavs = {11, 22};

  @override
  Future<Either<Failure, FavDataModel>> getFavData() async {
    return Right(FavDataModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': {
        'favourites': serverFavs
            .map((id) => {'id': id, 'name': 'P$id', 'image': 'i$id.jpg'})
            .toList(),
      },
    }));
  }

  @override
  Future<Either<Failure, GeneralModel>> addProductToFav(
      {required int productId}) async {
    serverFavs.add(productId);
    return Right(GeneralModel(status: true, message: 'added'));
  }

  @override
  Future<Either<Failure, GeneralModel>> removeProductFromFav(
      {required int productId}) async {
    serverFavs.remove(productId);
    return Right(GeneralModel(status: true, message: 'removed'));
  }
}

Widget _testApp() {
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
            BlocProvider(
              create: (_) => HomeCubit(FakeHomeRepo())
                ..getHome()
                ..getBanners(),
            ),
            BlocProvider(
              create: (_) => ProfileCubit(FakeProfileRepos()),
            ),
            BlocProvider(
              create: (_) => NotificationsCubit(FakeNotificationsRepos()),
            ),
            BlocProvider(
              create: (_) => FavCubit(FakeFavRepos())..getFavData(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: const HomeView(),
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'isGuest': false});
    await CacheHelper.init();
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('HomeView builds and pumps without semantics exceptions',
      (tester) async {
    await tester.pumpWidget(_testApp());
    // Shimmer animations never settle — pump a few frames manually.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(tester.takeException(), isNull);
  });
}
