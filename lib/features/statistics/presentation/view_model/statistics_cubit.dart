import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/statistics_model.dart';
import '../../data/repos/statistics_repos.dart';
import 'statistics_states.dart';

class StatisticsCubit extends Cubit<StatisticsStates> {
  StatisticsCubit(this.statisticsRepos) : super(StatisticsInitState());

  static StatisticsCubit get(BuildContext context) => BlocProvider.of(context);

  final StatisticsRepos statisticsRepos;

  StatisticsModel? statisticsModel;

  /// The month currently displayed by the timeline. Always the first day of
  /// that month.
  DateTime displayedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  /// The day the user tapped on the timeline (null = whole month).
  Days? selectedDay;

  Summary? get summary => statisticsModel?.data?.summary;
  List<Days> get days => statisticsModel?.data?.days ?? const [];
  Period? get period => statisticsModel?.data?.period;
  String get monthName => statisticsModel?.data?.monthName ?? '';

  String get monthKey => _monthKey(displayedMonth);

  /// Date used to position the timeline when it is (re)built.
  DateTime get initialDate {
    final selected = selectedDay?.date;
    if (selected != null) {
      final parsed = DateTime.tryParse(selected);
      if (parsed != null) return parsed;
    }
    final now = DateTime.now();
    if (now.year == displayedMonth.year && now.month == displayedMonth.month) {
      return now;
    }
    return DateTime(displayedMonth.year, displayedMonth.month, 1);
  }

  /// The period currently shown in the "period" card: the tapped day when
  /// there is one, otherwise the month returned by the backend.
  String get periodLabel {
    final day = selectedDay;
    if (day != null) {
      final date = day.date?.trim() ?? '';
      final name = day.dayName?.trim() ?? '';
      final label = '$name $date'.trim();
      return label.isNotEmpty ? label : monthName;
    }
    final p = period;
    if (p?.from != null && p?.to != null) {
      if (p!.from == p.to) return p.from!;
      return '${p.from} - ${p.to}';
    }
    return monthName;
  }

  int get periodSalesCount =>
      selectedDay?.salesCount ?? period?.salesCount ?? 0;
  int get periodSalesAmount =>
      selectedDay?.salesAmount ?? period?.salesAmount ?? 0;

  Future<void> getStatistics({String? month, String? date}) async {
    // Keep the current content while refreshing, show a full loader the
    // first time only.
    if (statisticsModel != null) {
      emit(StatisticsRefreshingState());
    } else {
      emit(StatisticsLoadingState());
    }

    final result = await statisticsRepos.getStatistics(
      month: month,
      date: date,
    );

    result.fold((failure) => emit(StatisticsErrorState(failure.errMessage)), (
      data,
    ) {
      statisticsModel = data;
      final parsedMonth = _parseMonth(data.data?.month);
      if (parsedMonth != null) displayedMonth = parsedMonth;
      selectedDay = _findDay(data.data?.selectedDate);
      emit(StatisticsSuccessState(data));
    });
  }

  void previousMonth() {
    final target = DateTime(displayedMonth.year, displayedMonth.month - 1);
    getStatistics(month: _monthKey(target));
  }

  void nextMonth() {
    final target = DateTime(displayedMonth.year, displayedMonth.month + 1);
    getStatistics(month: _monthKey(target));
  }

  /// Selecting a day is local: the backend already returns the per-day
  /// figures inside [days], so there is no need for another request.
  void selectDate(DateTime date) {
    final day = _findDay(_dateKey(date));
    selectedDay = day;
    emit(StatisticsDateSelectedState(day));
  }

  Future<void> refresh() async {
    final day = selectedDay?.date;
    if (day != null) {
      await getStatistics(date: day);
    } else {
      await getStatistics(month: monthKey);
    }
  }

  Days? _findDay(String? date) {
    if (date == null || date.isEmpty) return null;
    for (final day in days) {
      if (day.date == date) return day;
    }
    return null;
  }

  DateTime? _parseMonth(String? value) {
    if (value == null || value.isEmpty) return null;
    final parts = value.split('-');
    if (parts.length < 2) return null;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    if (year == null || month == null || month < 1 || month > 12) return null;
    return DateTime(year, month);
  }

  String _monthKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  String _dateKey(DateTime date) =>
      '${_monthKey(date)}-${date.day.toString().padLeft(2, '0')}';
}
