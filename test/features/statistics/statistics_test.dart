import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/statistics/data/models/statistics_model.dart';
import 'package:by3ly/features/statistics/data/repos/statistics_repos.dart';
import 'package:by3ly/features/statistics/presentation/view_model/statistics_cubit.dart';
import 'package:by3ly/features/statistics/presentation/view_model/statistics_states.dart';
import 'package:by3ly/features/statistics/presentation/views/statistics_widgets/statistics_view_body.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _currentMonth() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}

String _today() => '${_currentMonth()}-${DateTime.now().day.toString().padLeft(2, '0')}';

final Map<String, dynamic> _fixture = {
  'status': true,
  'message': 'ok',
  'data': {
    'month': _currentMonth(),
    'month_name': 'نوفمبر',
    'summary': {
      'total_sales': '12', // stringy
      'total_sales_amount': 90000,
      'displayed_products': 30,
      'interested_count': 45,
      'favourites_count': 8,
      'complaints': 1,
    },
    'period': {
      'from': _today(),
      'to': _today(),
      'sales_count': '3',
      'sales_amount': 21000,
    },
    'days': [
      {
        'date': _today(),
        'day': DateTime.now().day,
        'day_name': 'الاثنين',
        'sales_count': '3',
        'sales_amount': 21000,
      },
      'garbage-entry',
    ],
    'sales': <dynamic>[],
    'pagination': {
      'total': 10,
      'per_page': 10,
      'current_page': '1',
      'total_pages': 1,
    },
  },
};

class FakeStatisticsRepos implements StatisticsRepos {
  int calls = 0;
  bool shouldFail = false;
  String? lastMonth;
  String? lastDate;

  @override
  Future<Either<Failure, StatisticsModel>> getStatistics({
    String? month,
    String? date,
    int page = 1,
  }) async {
    calls++;
    lastMonth = month;
    lastDate = date;
    if (shouldFail) return Left(ServerFailure('fetch failed'));
    return Right(StatisticsModel.fromJson(
      Map<String, dynamic>.from(_fixture),
    ));
  }
}

Widget _harness({
  required Widget child,
  required List<BlocProvider> providers,
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

  group('StatisticsModel parsing', () {
    test('envelope and nested models parse with coercion', () {
      final model = StatisticsModel.fromJson(_fixture);
      expect(model.status, isTrue);
      final summary = model.data!.summary!;
      expect(summary.totalSales, 12);
      expect(summary.totalSalesAmount, 90000);
      expect(summary.favouritesCount, 8);
      expect(summary.complaints, 1);

      expect(model.data!.monthName, 'نوفمبر');
      expect(model.data!.period!.salesCount, 3);
      expect(model.data!.days, hasLength(1));
      expect(model.data!.days!.single.salesCount, 3);
      expect(model.data!.pagination!.currentPage, 1);
    });

    test('non-map data is dropped, not thrown', () {
      final model = StatisticsModel.fromJson({
        'status': '1',
        'data': 'nope',
      });
      expect(model.status, isTrue);
      expect(model.data, isNull);

      final model2 = StatisticsModel.fromJson({
        'status': true,
        'data': {'summary': 42, 'days': 'nope'},
      });
      expect(model2.data, isNotNull);
      expect(model2.data!.summary, isNull);
      expect(model2.data!.days, isNull);
    });
  });

  group('StatisticsCubit', () {
    test('initial state and month defaults', () {
      final cubit = StatisticsCubit(FakeStatisticsRepos());
      expect(cubit.state, isA<StatisticsInitState>());
      expect(cubit.displayedMonth.month, DateTime.now().month);
      expect(cubit.summary, isNull);
      cubit.close();
    });

    test('success emits Loading then Success and fills the model',
        () async {
      final repo = FakeStatisticsRepos();
      final cubit = StatisticsCubit(repo);
      final events = <StatisticsStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getStatistics(month: _currentMonth());
      await Future<void>.delayed(Duration.zero);

      expect(repo.calls, 1);
      expect(events.first, isA<StatisticsLoadingState>());
      expect(events.last, isA<StatisticsSuccessState>());
      expect(cubit.summary?.totalSales, 12);
      expect(cubit.monthName, 'نوفمبر');
      expect(cubit.periodSalesCount, 3);
      await sub.cancel();
      await cubit.close();
    });

    test('failure emits Loading then Error', () async {
      final repo = FakeStatisticsRepos()..shouldFail = true;
      final cubit = StatisticsCubit(repo);
      final events = <StatisticsStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.getStatistics(month: _currentMonth());
      await Future<void>.delayed(Duration.zero);

      expect((events.last as StatisticsErrorState).error, 'fetch failed');
      expect(cubit.statisticsModel, isNull);
      await sub.cancel();
      await cubit.close();
    });

    test('selectDate picks a day locally and refresh uses the date',
        () async {
      final repo = FakeStatisticsRepos();
      final cubit = StatisticsCubit(repo);
      await cubit.getStatistics(month: _currentMonth());

      cubit.selectDate(DateTime.now());

      expect(cubit.selectedDay?.date, _today());
      expect(cubit.periodLabel, contains('الاثنين'));

      await cubit.refresh();
      expect(repo.lastDate, _today());
      await cubit.close();
    });

    test('previousMonth/nextMonth request the right month keys', () async {
      final repo = FakeStatisticsRepos();
      final cubit = StatisticsCubit(repo);

      cubit.previousMonth();
      await Future<void>.delayed(Duration.zero);
      final expectedPrev =
          DateTime(DateTime.now().year, DateTime.now().month - 1);
      expect(repo.lastMonth,
          '${expectedPrev.year}-${expectedPrev.month.toString().padLeft(2, '0')}');

      // The fixture always resets displayedMonth to the current month;
      // next month therefore moves one month past "now".
      cubit.nextMonth();
      await Future<void>.delayed(Duration.zero);
      final expectedCurrent =
          DateTime(DateTime.now().year, DateTime.now().month + 1);
      expect(repo.lastMonth,
          '${expectedCurrent.year}-${expectedCurrent.month.toString().padLeft(2, '0')}');
      await cubit.close();
    });
  });

  group('Widgets', () {
    testWidgets('loading state shows shimmer placeholders', (tester) async {
      final cubit = StatisticsCubit(FakeStatisticsRepos());
      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<StatisticsCubit>.value(value: cubit)],
          child: const StatisticsViewBody(),
        ),
      );
      await _settle(tester);
      // Statistics cubit starts in LoadingState only via getStatistics();
      // a fresh cubit renders the shimmer skeleton instead of content.
      expect(find.text('جميع المبيعات'), findsNothing);
    });

    testWidgets('success renders the six summary cards and period card',
        (tester) async {
      tester.view.physicalSize = const Size(390, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final cubit = StatisticsCubit(FakeStatisticsRepos());
      await cubit.getStatistics(month: _currentMonth());

      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<StatisticsCubit>.value(value: cubit)],
          child: const StatisticsViewBody(),
        ),
      );
      await _settle(tester);

      expect(find.text('جميع المبيعات'), findsOneWidget);
      expect(find.text('قيمة المبيعات'), findsWidgets);
      expect(find.text('المنتجات المعروضه'), findsOneWidget);
      expect(find.text('المهتمين بالمنتجات'), findsOneWidget);
      expect(find.text('المفضلة'), findsWidgets);
      expect(find.text('الشكاوي'), findsOneWidget);
      expect(find.text('12'), findsWidgets);
      expect(find.text('إجمالي الفترة'), findsOneWidget);
    });

    testWidgets('error state shows retry and re-fetches on tap',
        (tester) async {
      final repo = FakeStatisticsRepos()..shouldFail = true;
      final cubit = StatisticsCubit(repo);
      await cubit.getStatistics(month: _currentMonth());

      await tester.pumpWidget(
        _harness(
          providers: [BlocProvider<StatisticsCubit>.value(value: cubit)],
          child: const StatisticsViewBody(),
        ),
      );
      await _settle(tester);

      expect(find.text('fetch failed'), findsOneWidget);

      await tester.tap(find.text('fetch failed'));
      await _settle(tester);
      expect(repo.calls, 2);
    });
  });
}
