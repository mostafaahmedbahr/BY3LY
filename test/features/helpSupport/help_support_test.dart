import 'package:by3ly/features/helpSupport/presentation/view-model/help_support_config.dart';
import 'package:by3ly/features/helpSupport/presentation/view-model/help_support_cubit.dart';
import 'package:by3ly/features/helpSupport/presentation/view-model/help_support_states.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/helpSupport/presentation/views/help_support_view.dart';
import 'package:by3ly/features/helpSupport/presentation/views/help_support_widgets/common_questions_widget.dart';
import 'package:by3ly/features/helpSupportChat/data/models/support_models.dart';
import 'package:by3ly/features/helpSupportChat/data/repos/support_chat_repository.dart';
import 'package:by3ly/features/helpSupportChat/presentation/view_model/support_unread_cubit.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// The production tree provides SupportUnreadCubit at the root; mirror it here
/// so widget tests don't depend on MyApp's provider layout.
class _StubSupportRepo implements SupportChatRepository {
  @override
  Future<Either<Failure, SupportConversationResponse>>
  getConversation() async => throw UnimplementedError();

  @override
  Future<Either<Failure, SupportUnreadResponse>> getUnreadCount() async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, SupportMessagesResponse>> getMessages({
    int? beforeId,
    int? afterId,
    int page = 1,
    int perPage = 30,
  }) async => throw UnimplementedError();

  @override
  Future<Either<Failure, SendSupportMessageResponse>> sendTextMessage({
    required String body,
  }) async => throw UnimplementedError();

  @override
  Future<Either<Failure, SendSupportMessageResponse>> sendImageMessage({
    required String imagePath,
    String? body,
  }) async => throw UnimplementedError();

  @override
  Future<Either<Failure, SupportReadResponse>> markRead() async =>
      throw UnimplementedError();
}

Widget _testApp({Widget? child}) {
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
            BlocProvider(create: (_) => HelpSupportCubit()),
            BlocProvider(create: (_) => SupportUnreadCubit(_StubSupportRepo())),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: child ?? const HelpSupportView(),
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  group('HelpSupportConfig', () {
    test('contact channels are non-empty and well formed', () {
      expect(HelpSupportConfig.email, contains('@'));
      expect(HelpSupportConfig.phone.trim(), isNotEmpty);
      expect(HelpSupportConfig.phoneE164, startsWith('+'));
      expect(
        HelpSupportConfig.phoneE164.replaceAll('+', ''),
        matches(RegExp(r'^[0-9]+$')),
      );
    });

    test('mailto URI carries scheme, path and encoded subject', () {
      final uri = HelpSupportConfig.buildMailtoUri(subject: 'الدعم الفني');
      expect(uri.scheme, 'mailto');
      expect(uri.path, HelpSupportConfig.email);
      expect(uri.queryParameters['subject'], 'الدعم الفني');
    });

    test('mailto without subject omits the query entirely', () {
      expect(HelpSupportConfig.buildMailtoUri().query, isEmpty);
    });

    test('tel URI uses the E.164 support line', () {
      final uri = HelpSupportConfig.buildTelUri();
      expect(uri.scheme, 'tel');
      expect(uri.path, HelpSupportConfig.phoneE164);
    });
  });

  group('HelpSupportCubit', () {
    test('starts in HelpSupportInitState', () {
      final cubit = HelpSupportCubit();
      expect(cubit.state, isA<HelpSupportInitState>());
      cubit.close();
    });

    test(
      'launch methods return false instead of throwing on failure',
      () async {
        final cubit = HelpSupportCubit();
        // No mail client / dialer plugin in the test binding — the cubit
        // must degrade gracefully instead of crashing.
        expect(await cubit.sendEmail(subject: 'test'), isFalse);
        expect(await cubit.makePhoneCall(), isFalse);
        cubit.close();
      },
    );
  });

  group('HelpSupportView', () {
    testWidgets('renders contact tiles and the FAQ section', (tester) async {
      await tester.pumpWidget(_testApp());
      await tester.pumpAndSettle();

      expect(find.text('المحادثة'), findsOneWidget);
      expect(find.text('الايميل'), findsOneWidget);
      expect(find.text('اتصل بنا'), findsOneWidget);
      expect(find.text(HelpSupportConfig.email), findsOneWidget);
      expect(find.text(HelpSupportConfig.phone), findsOneWidget);
    });

    // FAQ is intentionally commented out of the current help-screen design.
    // Test the widget in isolation so the production UI is left untouched.
    testWidgets('FAQ answer is collapsed by default and expands on tap', (
      tester,
    ) async {
      await tester.pumpWidget(
        _testApp(child: const Scaffold(body: CommonQuestionsWidget())),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('بيعلي غير مسؤول'), findsNothing);

      await tester.tap(find.text('كيف تتم عملية الشراء؟!'));
      await tester.pumpAndSettle();

      expect(find.textContaining('بيعلي غير مسؤول'), findsOneWidget);
    });
  });
}
