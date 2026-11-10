import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
import 'package:by3ly/features/notifications/data/models/notifications_model.dart';
import 'package:by3ly/features/notifications/data/repos/notifications_repos.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_states.dart';
import 'package:by3ly/features/notifications/presentation/views/notifications_view.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeNotificationsRepos implements NotificationsRepos {
  int getCalls = 0;
  int markReadCalls = 0;
  int markAllReadCalls = 0;
  int deleteOneCalls = 0;
  int deleteAllCalls = 0;

  bool shouldFail = false;
  bool statusFalse = false;

  /// Simulated server-side list.
  final List<Map<String, dynamic>> items;

  FakeNotificationsRepos({List<Map<String, dynamic>>? items})
      : items = items ??
            [
              {'id': '1', 'title': 'إشعار أول', 'body': 'body 1', 'is_read': false, 'created_at': '2026-11-01 10:00:00'},
              {'id': '2', 'title': 'إشعار ثاني', 'body': 'body 2', 'is_read': true, 'created_at': '2026-11-02 11:30:00'},
              {'id': '3', 'title': 'إشعار ثالث', 'body': 'body 3', 'is_read': false, 'created_at': '2026-11-03 12:00:00'},
            ];

  @override
  Future<Either<Failure, NotificationsModel>> getNotificationsData({
    required String type,
    int page = 1,
    int perPage = 15,
  }) async {
    getCalls++;
    if (shouldFail) return Left(ServerFailure('offline'));
    if (statusFalse) {
      return Right(NotificationsModel.fromJson({'status': false, 'message': 'rejected'}));
    }
    return Right(NotificationsModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': {
        'notifications': items,
        'pagination': {'current_page': page, 'last_page': 1, 'per_page': perPage, 'total': items.length},
        'unread_count': items.where((n) => n['is_read'] != true).length,
      },
    }));
  }

  @override
  Future<Either<Failure, GeneralModel>> markNotificationRead(
      {required String notificationId}) async {
    markReadCalls++;
    if (shouldFail) return Left(ServerFailure('offline'));
    for (final n in items) {
      if (n['id'] == notificationId) n['is_read'] = true;
    }
    return Right(GeneralModel(status: true, message: 'ok'));
  }

  @override
  Future<Either<Failure, GeneralModel>> markAllNotificationsRead() async {
    markAllReadCalls++;
    if (shouldFail) return Left(ServerFailure('offline'));
    for (final n in items) {
      n['is_read'] = true;
    }
    return Right(GeneralModel(status: true, message: 'ok'));
  }

  @override
  Future<Either<Failure, GeneralModel>> deleteNotification(
      {required String notificationId}) async {
    deleteOneCalls++;
    if (shouldFail) return Left(ServerFailure('offline'));
    items.removeWhere((n) => n['id'] == notificationId);
    return Right(GeneralModel(status: true, message: 'ok'));
  }

  @override
  Future<Either<Failure, GeneralModel>> deleteAllNotifications() async {
    deleteAllCalls++;
    if (shouldFail) return Left(ServerFailure('offline'));
    items.clear();
    return Right(GeneralModel(status: true, message: 'ok'));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
    await EasyLocalization.ensureInitialized();
  });

  group('NotificationsModel parsing', () {
    test('full envelope with pagination parses', () {
      final model = NotificationsModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'notifications': [
            {'id': '7', 'title': 'x', 'body': 'y', 'is_read': false},
          ],
          'pagination': {'current_page': 1, 'last_page': 3, 'per_page': 15},
          'unread_count': 1,
        },
      });
      expect(model.status, isTrue);
      expect(model.data?.notifications?.length, 1);
      expect(model.data?.pagination?.lastPage, 3);
      expect(model.data?.unreadCount, 1);
    });

    test('junk entries inside the notifications list are skipped', () {
      final model = NotificationsModel.fromJson({
        'status': true,
        'data': {
          'notifications': [
            {'id': '1', 'title': 'ok'},
            'junk',
            123,
          ],
        },
      });
      expect(model.data?.notifications?.length, 1);
    });

    test('data as a List does not crash the envelope', () {
      final model = NotificationsModel.fromJson({'status': true, 'data': []});
      expect(model.status, isTrue);
      expect(model.data, isNull);
    });

    test('read_at presence marks a notification as read', () {
      final model = NotificationsModel.fromJson({
        'status': true,
        'data': {
          'notifications': [
            {'id': '1', 'title': 'x', 'read_at': '2026-11-01 10:00:00'},
          ],
        },
      });
      expect(model.data!.notifications!.single.isRead, isTrue);
    });

    test('status 0/1/"true" parse correctly', () {
      expect(NotificationsModel.fromJson({'status': 1}).status, isTrue);
      expect(NotificationsModel.fromJson({'status': 'true'}).status, isTrue);
      expect(NotificationsModel.fromJson({'status': 0}).status, isFalse);
    });
  });

  group('NotificationsCubit', () {
    test('getNotificationsData replaces the list and syncs unreadCount',
        () async {
      final repo = FakeNotificationsRepos();
      final cubit = NotificationsCubit(repo);

      await cubit.getNotificationsData();

      expect(cubit.state, isA<GetNotificationsDataSuccess>());
      expect(cubit.notificationsList.length, 3);
      expect(cubit.unreadCount, 2);
      expect(cubit.currentPage, 1);
      expect(cubit.lastPage, 1);
    });

    test('server failure emits error with message', () async {
      final repo = FakeNotificationsRepos()..shouldFail = true;
      final cubit = NotificationsCubit(repo);

      await cubit.getNotificationsData();

      expect(cubit.state, isA<GetNotificationsDataError>());
      expect((cubit.state as GetNotificationsDataError).message, 'offline');
    });

    test('status false surfaces error with server message', () async {
      final repo = FakeNotificationsRepos()..statusFalse = true;
      final cubit = NotificationsCubit(repo);

      await cubit.getNotificationsData();

      expect(cubit.state, isA<GetNotificationsDataError>());
      expect((cubit.state as GetNotificationsDataError).message, 'rejected');
    });

    test('markAsRead flips the item and drops unreadCount', () async {
      final repo = FakeNotificationsRepos();
      final cubit = NotificationsCubit(repo);
      await cubit.getNotificationsData();

      await cubit.markAsRead('1');

      expect(repo.markReadCalls, 1);
      expect(cubit.unreadCount, 1);
      expect(cubit.notificationsList.firstWhere((n) => n.id == '1').isRead,
          isTrue);
    });

    test('markAllAsRead flips everything', () async {
      final repo = FakeNotificationsRepos();
      final cubit = NotificationsCubit(repo);
      await cubit.getNotificationsData();

      await cubit.markAllAsRead();

      expect(repo.markAllReadCalls, 1);
      expect(cubit.unreadCount, 0);
      expect(cubit.notificationsList.every((n) => n.isRead == true), isTrue);
    });

    test('deleteNotification removes the item locally and decrements unread',
        () async {
      final repo = FakeNotificationsRepos();
      final cubit = NotificationsCubit(repo);
      await cubit.getNotificationsData();

      await cubit.deleteNotification('1'); // unread

      expect(repo.deleteOneCalls, 1);
      expect(cubit.notificationsList.length, 2);
      expect(cubit.unreadCount, 1);
    });

    test('read filter applies client-side', () async {
      final repo = FakeNotificationsRepos();
      final cubit = NotificationsCubit(repo);
      await cubit.getNotificationsData();

      cubit.setReadFilter('read');
      expect(cubit.filteredNotifications.map((n) => n.id), ['2']);

      cubit.setReadFilter('unread');
      expect(cubit.filteredNotifications.map((n) => n.id), ['1', '3']);
    });
  });

  group('NotificationsView', () {
    Widget _app(NotificationsCubit cubit) {
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
            builder: (context) => BlocProvider(
              create: (_) => cubit,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                home: const NotificationsView(),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders items and read-status filter chips',
        (tester) async {
      final cubit = NotificationsCubit(FakeNotificationsRepos());
      await tester.pumpWidget(_app(cubit));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('إشعار أول'), findsOneWidget);
      expect(find.text('إشعار ثاني'), findsOneWidget);
      expect(find.text(LocaleKeys.filterAll.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.filterUnread.tr()), findsOneWidget);
    });
  });
}
