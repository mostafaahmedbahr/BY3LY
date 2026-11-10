import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
import 'package:by3ly/features/reportProduct/data/report_product_models/add_complaint_model.dart';
import 'package:by3ly/features/reportProduct/data/report_product_models/report_model.dart';
import 'package:by3ly/features/reportProduct/data/report_product_models/report_product_model.dart';
import 'package:by3ly/features/reportProduct/data/report_product_repos/report_product_repos.dart';
import 'package:by3ly/features/reportProduct/presentation/view_model/report_product_cubit.dart';
import 'package:by3ly/features/reportProduct/presentation/view_model/report_product_states.dart';
import 'package:by3ly/features/reportProduct/presentation/views/report_product_widgets/report_ad_view_body.dart';
import 'package:by3ly/features/reportProduct/presentation/views/report_product_widgets/report_the_product_view_body.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, dynamic> _complaintsJson = {
  'status': true,
  'message': 'ok',
  'data': {
    'complaints': [
      {'id': 1, 'text': 'احتيال ونصب'},
      {'id': 2, 'text': 'محتوى غير لائق'},
      {'id': '3', 'text': 'إعلان مضلل'},
      'garbage-entry',
    ],
  },
};

final Map<String, dynamic> _reasonsJson = {
  'status': true,
  'message': 'ok',
  'data': {
    'reasons': [
      {'id': 'r1', 'name': 'احتيال'},
      {'id': 'r2', 'name': 'محتوى غير لائق'},
    ],
  },
};

class FakeReportProductsRepos implements ReportProductsRepos {
  int getComplaintsTypesCalls = 0;
  int addComplaintCalls = 0;
  int getReportReasonsCalls = 0;
  int reportAdCalls = 0;

  bool complaintsShouldFail = false;
  bool addComplaintShouldFail = false;
  bool reasonsShouldFail = false;
  bool reportAdShouldFail = false;

  int? lastComplaintId;
  String? lastReportReason;
  String? lastReportDescription;

  @override
  Future<Either<Failure, ReportProductComplaintsTypesModel>>
      getComplaintsTypes() async {
    getComplaintsTypesCalls++;
    if (complaintsShouldFail) {
      return Left(ServerFailure('fetch failed'));
    }
    return Right(ReportProductComplaintsTypesModel.fromJson(
      Map<String, dynamic>.from(_complaintsJson),
    ));
  }

  @override
  Future<Either<Failure, AddComplaintModel>> addComplaint({
    int? sellerId,
    int? productId,
    required String message,
    required int complaintId,
  }) async {
    addComplaintCalls++;
    lastComplaintId = complaintId;
    if (addComplaintShouldFail) {
      return Left(ServerFailure('submit failed'));
    }
    return Right(AddComplaintModel.fromJson({
      'status': true,
      'number': 1,
      'message': 'تم استلام البلاغ',
    }));
  }

  @override
  Future<Either<Failure, ReportModel>> getReportReasons() async {
    getReportReasonsCalls++;
    if (reasonsShouldFail) {
      return Left(ServerFailure('reasons failed'));
    }
    return Right(ReportModel.fromJson(
      Map<String, dynamic>.from(_reasonsJson),
    ));
  }

  @override
  Future<Either<Failure, GeneralModel>> reportAd({
    required int sellerId,
    required int productId,
    required String reason,
    required String description,
  }) async {
    reportAdCalls++;
    lastReportReason = reason;
    lastReportDescription = description;
    if (reportAdShouldFail) {
      return Left(ServerFailure('report failed'));
    }
    return Right(GeneralModel(status: true, message: 'تم إرسال البلاغ'));
  }
}

Widget _harness({
  required Widget child,
  List<BlocProvider> providers = const [],
}) {
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
          providers: [...providers],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: Scaffold(body: child),
          ),
        ),
      ),
    ),
  );
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('ReportProduct models', () {
    test('complaints types parse with coercion and skip garbage entries', () {
      final model = ReportProductComplaintsTypesModel.fromJson(_complaintsJson);
      expect(model.status, isTrue);
      final complaints = model.data!.complaints!;
      expect(complaints.length, 3);
      expect(complaints[0].id, 1);
      expect(complaints[0].text, 'احتيال ونصب');
      expect(complaints[2].id, 3);
    });

    test('non-map data payload is dropped, not thrown', () {
      final model = ReportProductComplaintsTypesModel.fromJson({
        'status': '1',
        'data': 'nope',
      });
      expect(model.status, isTrue);
      expect(model.data, isNull);
    });

    test('reasons model coerces ids to strings', () {
      final model = ReportModel.fromJson({
        'status': '1',
        'data': {
          'reasons': [
            {'id': 41, 'name': 'احتيال'},
            'garbage',
          ],
        },
      });
      expect(model.status, isTrue);
      expect(model.data!.reasons!.single.id, '41');
      expect(model.data!.reasons!.single.name, 'احتيال');
    });

    test('add-complaint envelope coerces scalars', () {
      final model = AddComplaintModel.fromJson(
          {'status': '1', 'number': '9', 'message': 'ok'});
      expect(model.status, isTrue);
      expect(model.number, 9);
      expect(model.message, 'ok');
    });
  });

  group('ReportProductCubit', () {
    test('initial state', () {
      final cubit = ReportProductCubit(FakeReportProductsRepos());
      expect(cubit.state, isA<ReportProductInitState>());
      expect(cubit.reasonIndex, isNull);
      cubit.close();
    });

    test('getAllComplaintsTypesData success populates the list once',
        () async {
      final repo = FakeReportProductsRepos();
      final cubit = ReportProductCubit(repo);
      final events = <ReportProductStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getAllComplaintsTypesData();
      await Future<void>.delayed(Duration.zero);
      expect(repo.getComplaintsTypesCalls, 1);
      expect(cubit.allComplaintsTypesList.length, 3);
      expect(events.first, isA<GetComplaintsTypesLoading>());
      expect(events.last, isA<GetComplaintsTypesSuccess>());
      await sub.cancel();

      // Refetch must REPLACE the list, not accumulate duplicates.
      await cubit.getAllComplaintsTypesData();
      expect(cubit.allComplaintsTypesList.length, 3);
      await cubit.close();
    });

    test('getAllComplaintsTypesData failure emits Error', () async {
      final repo = FakeReportProductsRepos()..complaintsShouldFail = true;
      final cubit = ReportProductCubit(repo);
      final events = <ReportProductStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getAllComplaintsTypesData();
      await Future<void>.delayed(Duration.zero);

      expect(events.first, isA<GetComplaintsTypesLoading>());
      expect((events.last as GetComplaintsTypesError).message,
          'fetch failed');
      expect(cubit.allComplaintsTypesList, isEmpty);
      await sub.cancel();
      await cubit.close();
    });

    test('chooseReason selects, deselects via null and resets', () {
      final cubit = ReportProductCubit(FakeReportProductsRepos());
      cubit.chooseReason(2);
      expect(cubit.reasonIndex, 2);
      cubit.chooseReason(null);
      expect(cubit.reasonIndex, isNull);
      cubit.chooseReason(1);
      cubit.resetValues();
      expect(cubit.reasonIndex, isNull);
      expect(cubit.messageCon.text, isEmpty);
      cubit.close();
    });

    test('addComplaint success and failure flows', () async {
      final repo = FakeReportProductsRepos();
      final cubit = ReportProductCubit(repo);
      final events = <ReportProductStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.addComplaint(
        message: 'تفاصيل',
        complaintId: 3,
        sellerId: 7,
        productId: 11,
      );
      await Future<void>.delayed(Duration.zero);

      expect(repo.addComplaintCalls, 1);
      expect(repo.lastComplaintId, 3);
      expect(events.first, isA<AddComplaintLoading>());
      expect(events.last, isA<AddComplaintSuccess>());
      await sub.cancel();
      await cubit.close();

      final failRepo = FakeReportProductsRepos()
        ..addComplaintShouldFail = true;
      final failCubit = ReportProductCubit(failRepo);
      final failEvents = <ReportProductStates>[];
      final failSub = failCubit.stream.listen(failEvents.add);

      await failCubit.addComplaint(message: 'x', complaintId: 1);
      await Future<void>.delayed(Duration.zero);

      expect((failEvents.last as AddComplaintError).message, 'submit failed');
      await failSub.cancel();
      await failCubit.close();
    });

    test('getReportReasons is fetched once and cached', () async {
      final repo = FakeReportProductsRepos();
      final cubit = ReportProductCubit(repo);

      await cubit.getReportReasons();
      await cubit.getReportReasons();

      expect(repo.getReportReasonsCalls, 1);
      expect(cubit.reportReasons.length, 2);
      await cubit.close();
    });

    test('submitReportAd without a selection emits selectReason and skips the repo',
        () async {
      final repo = FakeReportProductsRepos();
      final cubit = ReportProductCubit(repo);
      final events = <ReportProductStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.submitReportAd(sellerId: 7, productId: 11);
      await Future<void>.delayed(Duration.zero);

      expect(events.single, isA<ReportAdError>());
      expect((events.single as ReportAdError).message, 'selectReason');
      expect(repo.reportAdCalls, 0);
      await sub.cancel();
      await cubit.close();
    });

    test('submitReportAd success resets the selection afterwards', () async {
      final repo = FakeReportProductsRepos();
      final cubit = ReportProductCubit(repo);
      final events = <ReportProductStates>[];
      final sub = cubit.stream.listen(events.add);

      cubit.selectReportReason('r1');
      cubit.reportDescCon.text = 'احتيال واضح';
      await cubit.submitReportAd(sellerId: 7, productId: 11);
      await Future<void>.delayed(Duration.zero);

      expect(repo.reportAdCalls, 1);
      expect(repo.lastReportReason, 'r1');
      expect(repo.lastReportDescription, 'احتيال واضح');
      expect(events.whereType<ReportAdSuccess>(), hasLength(1));
      expect(cubit.selectedReasonKey, isNull);
      expect(cubit.reportDescCon.text, isEmpty);
      await sub.cancel();
      await cubit.close();
    });
  });

  group('Report widgets', () {
    testWidgets('complaint body renders reasons and submits the selection',
        (tester) async {
      tester.view.physicalSize = const Size(390, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final repo = FakeReportProductsRepos();
      final cubit = ReportProductCubit(repo);
      await cubit.getAllComplaintsTypesData();

      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<ReportProductCubit>.value(value: cubit)],
          child: const ReportTheProductViewBody(),
        ),
      );
      await _settle(tester);

      expect(find.text('احتيال ونصب'), findsOneWidget);
      expect(find.text('إعلان مضلل'), findsOneWidget);

      // Send without selecting anything — nothing is submitted.
      await tester.tap(find.text('ارسال'));
      await _settle(tester);
      expect(repo.addComplaintCalls, 0);

      // Select a reason and send.
      await tester.tap(find.text('محتوى غير لائق'));
      await _settle(tester);
      expect(cubit.reasonIndex, 2);

      await tester.tap(find.text('ارسال'));
      await _settle(tester);
      expect(repo.addComplaintCalls, 1);
      expect(repo.lastComplaintId, 2);
    });

    testWidgets('ad body loads reasons, selects one and submits',
        (tester) async {
      tester.view.physicalSize = const Size(390, 1500);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final repo = FakeReportProductsRepos();
      final cubit = ReportProductCubit(repo);

      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<ReportProductCubit>.value(value: cubit)],
          child: const ReportAdViewBody(sellerId: 7, productId: 11),
        ),
      );
      await _settle(tester);

      expect(repo.getReportReasonsCalls, 1);
      expect(find.text('احتيال'), findsOneWidget);

      // Submit without selecting — nothing is sent.
      await tester.tap(find.text('ارسال'));
      await _settle(tester);
      expect(repo.reportAdCalls, 0);

      await tester.tap(find.text('احتيال'));
      await _settle(tester);
      expect(cubit.selectedReasonKey, 'r1');

      await tester.tap(find.text('ارسال'));
      await _settle(tester);
      expect(repo.reportAdCalls, 1);
      expect(repo.lastReportReason, 'r1');
      expect(cubit.selectedReasonKey, isNull);
    });
  });
}
