import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/howToMakePurchase/data/models/how_to_make_purchase_model.dart';
import 'package:by3ly/features/howToMakePurchase/data/repos/how_to_make_purchase_repos_imple.dart';
import 'package:by3ly/features/howToMakePurchase/presentation/view_model/how_to_make_purchase_cubit.dart';
import 'package:by3ly/features/howToMakePurchase/presentation/view_model/how_to_make_purchase_states.dart';
import 'package:by3ly/features/howToMakePurchase/presentation/views/how_to_make_purchase_view.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeHowToMakePurchaseRepo extends HowToMakePurchaseRepoImpl {
  FakeHowToMakePurchaseRepo({
    this.succeed = true,
    this.message = 'ok',
  }) : super(null);

  final bool succeed;
  final String message;

  int calls = 0;

  @override
  Future<Either<Failure, HowToMakePurchaseModel>> getHowToMakePurchaseData()
      async {
    calls++;
    if (!succeed) return Left(ServerFailure('offline'));
    return Right(HowToMakePurchaseModel.fromJson({
      'status': true,
      'message': message,
      'data': {
        'id': 1,
        'title': 'تعليمات الشراء',
        'html': '<p>خطوة بخطوة</p><ul><li>تواصل مع البائع</li></ul>',
        'language': 'ar',
        'direction': 'rtl',
        'updated_at': '2026-11-06 10:00:00',
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
          home: child ?? const HowToMakePurchaseView(),
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
    if (getIt.isRegistered<HowToMakePurchaseRepoImpl>()) {
      await getIt.unregister<HowToMakePurchaseRepoImpl>();
    }
  });

  group('HowToMakePurchaseModel parsing', () {
    test('full envelope parses', () {
      final model = HowToMakePurchaseModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {'id': 1, 'title': 'تعليمات', 'html': '<p>x</p>'},
      });
      expect(model.status, isTrue);
      expect(model.data?.title, 'تعليمات');
      expect(model.data?.html, '<p>x</p>');
    });

    test('status 1 / "true" parse as true, status 0 as false', () {
      expect(HowToMakePurchaseModel.fromJson({'status': 1}).status, isTrue);
      expect(HowToMakePurchaseModel.fromJson({'status': 'true'}).status,
          isTrue);
      expect(HowToMakePurchaseModel.fromJson({'status': 0}).status, isFalse);
    });

    test('non-map data keeps the app alive instead of crashing', () {
      final model = HowToMakePurchaseModel.fromJson({
        'status': true,
        'data': ['unexpected', 'list'],
      });
      expect(model.status, isTrue);
      expect(model.data, isNull);
    });
  });

  group('HowToMakePurchaseCubit', () {
    test('success emits Success with the payload', () async {
      final cubit = HowToMakePurchaseCubit(FakeHowToMakePurchaseRepo());
      await cubit.getHowToMakePurchaseData();
      expect(cubit.state, isA<GetHowToMakePurchaseDataSuccessState>());
      expect(cubit.howToMakePurchaseModel?.data?.title, 'تعليمات الشراء');
    });

    test('failure emits Error with the failure message', () async {
      final cubit =
          HowToMakePurchaseCubit(FakeHowToMakePurchaseRepo(succeed: false));
      await cubit.getHowToMakePurchaseData();
      expect(cubit.state, isA<GetHowToMakePurchaseDataErrorState>());
      expect((cubit.state as GetHowToMakePurchaseDataErrorState).error,
          'offline');
    });
  });

  group('HowToMakePurchaseView', () {
    testWidgets('renders instructions from the server payload',
        (tester) async {
      final repo = FakeHowToMakePurchaseRepo();
      if (getIt.isRegistered<HowToMakePurchaseRepoImpl>()) {
        await getIt.unregister<HowToMakePurchaseRepoImpl>();
      }
      getIt.registerSingleton<HowToMakePurchaseRepoImpl>(repo);

      await tester.pumpWidget(_testApp());
      // The shimmer never settles — pump manually instead.
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('تعليمات الشراء'), findsOneWidget);
      expect(find.text('خطوة بخطوة'), findsOneWidget);
      expect(find.textContaining('تواصل مع الدعم'), findsOneWidget);
      expect(repo.calls, greaterThanOrEqualTo(1));
    });

    testWidgets('error payload shows the error widget with a retry',
        (tester) async {
      final repo = FakeHowToMakePurchaseRepo(succeed: false);
      if (getIt.isRegistered<HowToMakePurchaseRepoImpl>()) {
        await getIt.unregister<HowToMakePurchaseRepoImpl>();
      }
      getIt.registerSingleton<HowToMakePurchaseRepoImpl>(repo);

      await tester.pumpWidget(_testApp());
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
