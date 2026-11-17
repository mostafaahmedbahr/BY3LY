import 'dart:io';

import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/app_services/local_services/cache_token.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/utils/app_consts/storage_keys.dart';
import 'package:by3ly/features/helpSupportChat/data/models/support_models.dart';
import 'package:by3ly/features/helpSupportChat/data/repos/support_chat_repository_impl.dart';
import 'package:by3ly/features/helpSupportChat/presentation/view_model/help_support_chat_cubit.dart';
import 'package:by3ly/features/helpSupportChat/presentation/view_model/help_support_chat_states.dart';
import 'package:by3ly/features/helpSupportChat/presentation/view_model/support_chat_rules.dart';
import 'package:by3ly/features/helpSupportChat/presentation/view_model/support_unread_cubit.dart';
import 'package:by3ly/features/helpSupportChat/presentation/views/help_support_chat_view.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory support backend used by cubit integration tests.
class FakeSupportChatRepo extends SupportChatRepositoryImpl {
  FakeSupportChatRepo() : super(null);

  bool failConversation = false;
  bool failMessages = false;
  bool failSend = false;
  bool failMarkRead = false;
  bool failUnread = false;
  bool messagesStatus = true;
  bool sendStatus = true;

  int conversationCalls = 0;
  int messagesCalls = 0;
  int sendTextCalls = 0;
  int sendImageCalls = 0;
  int markReadCalls = 0;
  int unreadCalls = 0;

  int? lastBeforeId;
  int? lastAfterId;
  String? lastBody;
  String? lastImagePath;

  final List<SupportMessageModel> serverMessages = [];
  int nextId = 100;
  int nextUnread = 0;

  SupportMessageModel _msg({
    required int id,
    required String body,
    bool mine = false,
    bool fromSupport = false,
    bool isRead = false,
    String type = 'text',
    String? image,
  }) => SupportMessageModel(
    id: id,
    conversationId: 1,
    type: type,
    body: body,
    image: image,
    isMine: mine,
    isFromSupport: fromSupport,
    senderRole: fromSupport ? 'admin' : 'user',
    isRead: isRead,
    createdAt: '2026-11-17 10:00:00',
  );

  @override
  Future<Either<Failure, SupportConversationResponse>> getConversation() async {
    conversationCalls++;
    if (failConversation) return Left(ServerFailure('offline'));
    return Right(
      SupportConversationResponse.fromJson({
        'status': true,
        'data': {
          'conversation': {'id': 1},
        },
      }),
    );
  }

  @override
  Future<Either<Failure, SupportUnreadResponse>> getUnreadCount() async {
    unreadCalls++;
    if (failUnread) return Left(ServerFailure('offline'));
    return Right(
      SupportUnreadResponse.fromJson({
        'status': true,
        'data': {'unread_count': nextUnread},
      }),
    );
  }

  @override
  Future<Either<Failure, SupportMessagesResponse>> getMessages({
    int? beforeId,
    int? afterId,
    int page = 1,
    int perPage = 30,
  }) async {
    messagesCalls++;
    lastBeforeId = beforeId;
    lastAfterId = afterId;
    if (failMessages) return Left(ServerFailure('offline'));

    final items = afterId != null
        ? serverMessages.where((m) => (m.id ?? 0) > afterId).toList()
        : beforeId != null
        ? serverMessages.where((m) => (m.id ?? 0) < beforeId).toList()
        : serverMessages.toList();

    return Right(
      SupportMessagesResponse.fromJson({
        'status': messagesStatus,
        'message': 'ok',
        'data': {
          'messages': items.map((m) => m.toJson()).toList(),
          'pagination': {
            'current_page': page,
            'per_page': perPage,
            // Keep history "available" so loadOlderMessages is exercised.
            'total': serverMessages.length + 10,
            'last_page': 2,
          },
        },
      }),
    );
  }

  @override
  Future<Either<Failure, SendSupportMessageResponse>> sendTextMessage({
    required String body,
  }) async {
    sendTextCalls++;
    lastBody = body;
    if (failSend) return Left(ServerFailure('offline'));
    final created = _msg(id: nextId++, body: body, mine: true);
    serverMessages.insert(0, created);
    return Right(
      SendSupportMessageResponse.fromJson({
        'status': sendStatus,
        'data': {'message': created.toJson()},
      }),
    );
  }

  @override
  Future<Either<Failure, SendSupportMessageResponse>> sendImageMessage({
    required String imagePath,
    String? body,
  }) async {
    sendImageCalls++;
    lastImagePath = imagePath;
    if (failSend) return Left(ServerFailure('offline'));
    final id = nextId++;
    final created = _msg(
      id: id,
      body: body ?? '',
      mine: true,
      type: 'image',
      image: '/api/support/messages/$id/image',
    );
    serverMessages.insert(0, created);
    return Right(
      SendSupportMessageResponse.fromJson({
        'status': true,
        'data': {'message': created.toJson()},
      }),
    );
  }

  @override
  Future<Either<Failure, SupportReadResponse>> markRead() async {
    markReadCalls++;
    if (failMarkRead) return Left(ServerFailure('offline'));
    nextUnread = 0;
    return Right(
      SupportReadResponse.fromJson({
        'status': true,
        'data': {'unread_count': 0},
      }),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({StorageKeys.isGuest: false});
    await CacheHelper.init();
  });

  setUp(() {
    CacheTokenManger.userToken = 'tok-test';
  });

  tearDown(() {
    CacheTokenManger.userToken = null;
  });

  group('SupportChatRules', () {
    test('image validation accepts jpg/png/webp and rejects gif/pdf', () {
      expect(SupportChatRules.imageExtension('p.JPG'), 'jpg');
      expect(SupportChatRules.imageExtension('noext'), '');
      expect(SupportChatRules.isAllowedImageExtension('a.webp'), isTrue);
      expect(SupportChatRules.isAllowedImageExtension('a.gif'), isFalse);
      expect(SupportChatRules.isAllowedImageExtension('a.pdf'), isFalse);
      expect(SupportChatRules.isAllowedImageSize(0), isTrue);
      expect(
        SupportChatRules.isAllowedImageSize(SupportChatRules.maxImageBytes + 1),
        isFalse,
      );
    });

    test('message helpers sort, dedupe and mark read without mutating', () {
      final a = SupportMessageModel(id: 1, body: 'a', isRead: false);
      final b = SupportMessageModel(id: 2, body: 'b', isRead: false);
      final sorted = SupportChatRules.sortedMessagesDesc([a, b]);
      expect(sorted.first.id, 2);
      expect(SupportChatRules.sameMessageIds(sorted, [b, a]), isTrue);
      expect(SupportChatRules.filterNewMessages([a, b], [b]).single.id, 1);
      final marked = SupportChatRules.markAllMessagesRead([a]);
      expect(marked.single.isRead, isTrue);
      expect(a.isRead, isFalse);
    });
  });

  group('Support models', () {
    test('tolerant parsing for ids, booleans and response shapes', () {
      final message = SupportMessageModel.fromJson({
        'id': '12',
        'is_read': 1,
        'is_from_support': 'true',
        'type': 'text',
        'body': 'hello',
      });
      expect(message.id, 12);
      expect(message.isRead, isTrue);
      expect(message.fromSupport, isTrue);

      final messages = SupportMessagesResponse.fromJson({
        'status': true,
        'data': {
          'messages': [
            'junk',
            {'id': 1, 'body': 'ok'},
          ],
        },
      });
      expect(messages.messages?.length, 1);
      expect(messages.messages?.single.body, 'ok');
    });
  });

  group('HelpSupportChatCubit integration', () {
    test('init loads conversation, history and marks messages read', () async {
      final repo = FakeSupportChatRepo();
      final unread = SupportUnreadCubit(repo);
      final cubit = HelpSupportChatCubit(repo, unread);
      addTearDown(() async {
        await cubit.close();
        await unread.close();
      });
      repo.serverMessages.add(SupportMessageModel(id: 1, body: 'hello'));

      await cubit.init();

      expect(repo.conversationCalls, 1);
      expect(repo.messagesCalls, 1);
      expect(cubit.messages.single.body, 'hello');
      expect(repo.markReadCalls, 1);
      expect(unread.count, 0);
      // markRead is fire-and-forget in the cubit; let it settle.
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state, isA<SupportChatMarkedRead>());
    });

    test('conversation failure does not block history loading', () async {
      final repo = FakeSupportChatRepo()..failConversation = true;
      final unread = SupportUnreadCubit(repo);
      final cubit = HelpSupportChatCubit(repo, unread);
      addTearDown(() async {
        await cubit.close();
        await unread.close();
      });
      repo.serverMessages.add(SupportMessageModel(id: 1, body: 'hello'));

      await cubit.init();

      expect(repo.messagesCalls, 1);
      expect(cubit.messages.single.body, 'hello');
    });

    test('load failure emits error and retry recovers', () async {
      final repo = FakeSupportChatRepo()..failMessages = true;
      final unread = SupportUnreadCubit(repo);
      final cubit = HelpSupportChatCubit(repo, unread);
      addTearDown(() async {
        await cubit.close();
        await unread.close();
      });

      await cubit.loadMessages();
      expect(cubit.state, isA<SupportChatMessagesError>());
      expect((cubit.state as SupportChatMessagesError).message, 'offline');

      repo
        ..failMessages = false
        ..serverMessages.add(SupportMessageModel(id: 1, body: 'recovered'));
      await cubit.loadMessages();
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state, isA<SupportChatMarkedRead>());
      expect(cubit.messages.single.body, 'recovered');
    });

    test('sendText trims, dedupes and blocks double taps', () async {
      final repo = FakeSupportChatRepo();
      final cubit = HelpSupportChatCubit(repo, SupportUnreadCubit(repo));
      addTearDown(() async {
        await cubit.close();
      });

      expect(await cubit.sendText('   مرحبا   '), isTrue);
      expect(repo.lastBody, 'مرحبا');
      expect(cubit.messages.single.body, 'مرحبا');
      expect(cubit.state, isA<SupportChatMessageSent>());

      // Two simultaneous sends of the same text issue a single request.
      await Future.wait([cubit.sendText('a'), cubit.sendText('a')]);
      expect(repo.sendTextCalls, 2); // first call + one from the double tap
    });

    test('sendText failure emits an error state', () async {
      final repo = FakeSupportChatRepo()..failSend = true;
      final cubit = HelpSupportChatCubit(repo, SupportUnreadCubit(repo));
      addTearDown(cubit.close);

      expect(await cubit.sendText('x'), isFalse);
      expect(cubit.state, isA<SupportChatMessageSendError>());
      expect((cubit.state as SupportChatMessageSendError).message, 'offline');
    });

    test('poll inserts new support replies and marks them read', () async {
      final repo = FakeSupportChatRepo();
      final unread = SupportUnreadCubit(repo)..setCount(3);
      final cubit = HelpSupportChatCubit(repo, unread);
      addTearDown(() async {
        await cubit.close();
        await unread.close();
      });
      repo.serverMessages.add(SupportMessageModel(id: 1, body: 'old'));
      await cubit.init();

      repo.serverMessages.insert(
        0,
        SupportMessageModel(
          id: 2,
          body: 'رد الدعم',
          isFromSupport: true,
          senderRole: 'admin',
          isRead: false,
        ),
      );
      await cubit.poll();

      expect(repo.lastAfterId, 1);
      expect(cubit.messages.first.body, 'رد الدعم');
      await Future<void>.delayed(Duration.zero);
      expect(cubit.messages.every((m) => m.isRead == true), isTrue);
      expect(unread.count, 0);
    });

    test('loadOlderMessages uses before_id and appends history', () async {
      final repo = FakeSupportChatRepo();
      final cubit = HelpSupportChatCubit(repo, SupportUnreadCubit(repo));
      addTearDown(cubit.close);
      repo.serverMessages.add(SupportMessageModel(id: 5, body: 'newest'));
      await cubit.init();
      repo.serverMessages.insert(0, SupportMessageModel(id: 4, body: 'older'));

      await cubit.loadOlderMessages();

      expect(repo.lastBeforeId, 5);
      expect(cubit.messages.map((m) => m.id), [5, 4]);
    });

    test('older messages failure emits a retryable error', () async {
      final repo = FakeSupportChatRepo();
      final cubit = HelpSupportChatCubit(repo, SupportUnreadCubit(repo));
      addTearDown(cubit.close);
      repo.serverMessages.add(SupportMessageModel(id: 5, body: 'newest'));
      await cubit.init();
      repo.failMessages = true;

      await cubit.loadOlderMessages();

      expect(cubit.state, isA<SupportChatOlderMessagesError>());
    });

    test(
      'sendImage accepts a real jpg file and inserts the image message',
      () async {
        final repo = FakeSupportChatRepo();
        final cubit = HelpSupportChatCubit(repo, SupportUnreadCubit(repo));
        addTearDown(cubit.close);
        final file = File(
          '${Directory.systemTemp.path}/by3ly_support_test.jpg',
        );
        await file.writeAsBytes(List<int>.filled(16, 0xff));
        addTearDown(() async {
          if (await file.exists()) await file.delete();
        });

        expect(await cubit.sendImage(file.path), isTrue);
        expect(repo.sendImageCalls, 1);
        expect(repo.lastImagePath, file.path);
        expect(cubit.messages.first.type, 'image');
        expect(cubit.messages.first.image, isNotNull);
      },
    );

    test(
      'sendImage rejects bad extension and missing files without a request',
      () async {
        final repo = FakeSupportChatRepo();
        final cubit = HelpSupportChatCubit(repo, SupportUnreadCubit(repo));
        addTearDown(cubit.close);

        expect(await cubit.sendImage('/tmp/photo.gif'), isFalse);
        expect(
          (cubit.state as SupportChatMessageSendError).message,
          'unsupportedImageType',
        );

        expect(await cubit.sendImage('/tmp/missing.jpg'), isFalse);
        expect(
          (cubit.state as SupportChatMessageSendError).message,
          'imageTooLarge',
        );
        expect(repo.sendImageCalls, 0);
      },
    );

    test('sendImage failure emits an error state', () async {
      final repo = FakeSupportChatRepo()..failSend = true;
      final cubit = HelpSupportChatCubit(repo, SupportUnreadCubit(repo));
      addTearDown(cubit.close);
      final file = File('${Directory.systemTemp.path}/by3ly_support_fail.png');
      await file.writeAsBytes(List<int>.filled(8, 0x01));
      addTearDown(() async {
        if (await file.exists()) await file.delete();
      });

      expect(await cubit.sendImage(file.path), isFalse);
      expect(cubit.state, isA<SupportChatMessageSendError>());
    });
  });

  group('SupportUnreadCubit', () {
    test('success sets count and failures are silent', () async {
      final repo = FakeSupportChatRepo()..nextUnread = 4;
      final cubit = SupportUnreadCubit(repo);
      addTearDown(cubit.close);

      await cubit.refresh();
      expect(cubit.count, 4);

      await cubit.refresh();
      expect(repo.unreadCalls, 2);

      repo.nextUnread = 1;
      repo.failUnread = true;
      await cubit.refresh();
      expect(cubit.count, 4);
    });

    test('negative counts are clamped to zero', () {
      final cubit = SupportUnreadCubit(FakeSupportChatRepo());
      addTearDown(cubit.close);
      cubit.setCount(-5);
      expect(cubit.count, 0);
    });

    test('guest mode never calls the backend', () async {
      SharedPreferences.setMockInitialValues({StorageKeys.isGuest: true});
      await CacheHelper.init();
      final repo = FakeSupportChatRepo();
      final cubit = SupportUnreadCubit(repo);
      addTearDown(cubit.close);

      await cubit.refresh();

      expect(repo.unreadCalls, 0);
      expect(cubit.count, 0);
      SharedPreferences.setMockInitialValues({StorageKeys.isGuest: false});
      await CacheHelper.init();
    });
  });

  group('HelpSupportChatView', () {
    testWidgets('error state shows a retry widget that refetches messages', (
      tester,
    ) async {
      final repo = FakeSupportChatRepo()..failMessages = true;
      final unread = SupportUnreadCubit(repo);
      final cubit = HelpSupportChatCubit(repo, unread);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, _) => EasyLocalization(
            startLocale: const Locale('ar'),
            supportedLocales: const [Locale('ar'), Locale('en')],
            path: 'assets/lang',
            fallbackLocale: const Locale('en'),
            assetLoader: const CodegenLoader(),
            child: Builder(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<HelpSupportChatCubit>.value(value: cubit),
                  BlocProvider<SupportUnreadCubit>.value(value: unread),
                ],
                child: MaterialApp(
                  locale: context.locale,
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
                  home: const HelpSupportChatView(),
                ),
              ),
            ),
          ),
        ),
      );
      // Polling timer + shimmer: never use pumpAndSettle here.
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('offline'), findsOneWidget);

      repo
        ..failMessages = false
        ..serverMessages.add(SupportMessageModel(id: 1, body: 'بعد الإعادة'));
      await tester.tap(find.text('offline'));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(repo.messagesCalls, greaterThanOrEqualTo(2));
      expect(find.text('بعد الإعادة'), findsOneWidget);

      // Stop the polling timer before the test framework checks for pending
      // timers (close() here, not only in addTearDown).
      await cubit.close();
      await unread.close();
    });
  });
}
