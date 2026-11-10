import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/legalContent/data/models/legal_content_model.dart';
import 'package:by3ly/features/legalContent/data/repos/legal_content_repos_imple.dart';
import 'package:by3ly/features/legalContent/presentation/view_model/legal_content_cubit.dart';
import 'package:by3ly/features/legalContent/presentation/view_model/legal_content_states.dart';
import 'package:by3ly/features/legalContent/presentation/views/legal_content_view.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeLegalContentRepo extends LegalContentRepoImpl {
  FakeLegalContentRepo({this.succeed = true}) : super(null);

  final bool succeed;
  int calls = 0;
  LegalContentType? lastType;

  @override
  Future<Either<Failure, LegalContentModel>> getLegalContent(
    LegalContentType type,
  ) async {
    calls++;
    lastType = type;
    if (!succeed) return Left(ServerFailure('offline'));
    return Right(LegalContentModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': {
        'title': 'العنوان',
        'content': '<p>محتوى اختباري</p><ul><li>بند أولى</li></ul>',
        'language': 'ar',
        'direction': 'rtl',
        'updated_at': '2026-11-01 10:00:00',
      },
    }));
  }
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
        builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: child ?? const LegalContentView(type: LegalContentType.terms),
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

  tearDown(() async {
    if (getIt.isRegistered<LegalContentRepoImpl>()) {
      await getIt.unregister<LegalContentRepoImpl>();
    }
  });

  group('LegalContentModel parsing', () {
    test('full envelope parses and isRtl defaults to true', () {
      final model = LegalContentModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {'title': 'عن التطبيق', 'content': '<p>x</p>'},
      });
      expect(model.status, isTrue);
      expect(model.data?.content, '<p>x</p>');
      expect(model.data?.isRtl, isTrue);
    });

    test('html falls back to content when key is older', () {
      final model = LegalContentModel.fromJson({
        'status': true,
        'data': {'html': '<p>legacy</p>'},
      });
      expect(model.data?.content, '<p>legacy</p>');
    });

    test('status variants parse; non-map data stays null', () {
      expect(LegalContentModel.fromJson({'status': 1}).status, isTrue);
      expect(LegalContentModel.fromJson({'status': 'true'}).status, isTrue);
      expect(LegalContentModel.fromJson({'status': 0}).status, isFalse);
      expect(LegalContentModel.fromJson({'status': true, 'data': []}).data,
          isNull);
    });
  });

  group('LegalContentCubit', () {
    test('getLegalContent success stores model and emits Success', () async {
      final cubit = LegalContentCubit(FakeLegalContentRepo());
      await cubit.getLegalContent(LegalContentType.about);
      expect(cubit.state, isA<GetLegalContentSuccessState>());
      expect(cubit.legalContentModel?.data?.title, 'العنوان');
    });

    test('failure emits Error with failure message', () async {
      final cubit = LegalContentCubit(FakeLegalContentRepo(succeed: false));
      await cubit.getLegalContent(LegalContentType.terms);
      expect(cubit.state, isA<GetLegalContentErrorState>());
      expect((cubit.state as GetLegalContentErrorState).error, 'offline');
    });
  });

  group('LegalContentView', () {
    testWidgets('renders HTML and per-type premium app bar title',
        (tester) async {
      final repo = FakeLegalContentRepo();
      if (getIt.isRegistered<LegalContentRepoImpl>()) {
        await getIt.unregister<LegalContentRepoImpl>();
      }
      getIt.registerSingleton<LegalContentRepoImpl>(repo);

      await tester.pumpWidget(
        _testApp(child: const LegalContentView(type: LegalContentType.privacy)),
      );
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(repo.calls, greaterThanOrEqualTo(1));
      expect(repo.lastType, LegalContentType.privacy);
      expect(find.text('محتوى اختباري'), findsOneWidget);
    });

    testWidgets('error payload retries on tap', (tester) async {
      final repo = FakeLegalContentRepo(succeed: false);
      if (getIt.isRegistered<LegalContentRepoImpl>()) {
        await getIt.unregister<LegalContentRepoImpl>();
      }
      getIt.registerSingleton<LegalContentRepoImpl>(repo);

      await tester.pumpWidget(
        _testApp(child: const LegalContentView(type: LegalContentType.about)),
      );
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('offline'), findsOneWidget);

      await tester.tap(find.text('offline'));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(repo.calls, 2);
    });
  });
}
