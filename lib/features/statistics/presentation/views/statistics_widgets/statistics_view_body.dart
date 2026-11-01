import 'dart:ui' as ui;

import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/statistics/data/models/statistics_model.dart';
import 'package:by3ly/features/statistics/presentation/view_model/statistics_cubit.dart';
import 'package:by3ly/features/statistics/presentation/view_model/statistics_states.dart';
import 'package:by3ly/features/statistics/presentation/views/statistics_widgets/statistics_item.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsViewBody extends StatelessWidget {
  const StatisticsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsStates>(
      builder: (context, state) {
        final cubit = StatisticsCubit.get(context);

        // First load.
        if (state is StatisticsLoadingState) {
          return const CustomLoading();
        }

        // Failure: show the retry widget like the other features do.
        if (state is StatisticsErrorState) {
          return CustomErrorWidget(
            error: state.error,
            onTap: () => cubit.getStatistics(month: cubit.monthKey),
          );
        }

        // Init / unexpected state before the first response.
        if (cubit.statisticsModel == null) {
          return const CustomLoading();
        }

        return RefreshIndicator(
          color: AppColors.accent,
          onRefresh: cubit.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _MonthSelector(
                cubit: cubit,
                refreshing: state is StatisticsRefreshingState,
              ),
              const SizedBox(height: 14),
              _SummaryGrid(summary: cubit.summary),
              const SizedBox(height: 16),
              _PeriodCard(cubit: cubit),
              const SizedBox(height: 16),
              _DayTimeline(cubit: cubit),
            ],
          ),
        );
      },
    );
  }
}

/// Month name with previous/next arrows.
class _MonthSelector extends StatelessWidget {
  const _MonthSelector({required this.cubit, required this.refreshing});

  final StatisticsCubit cubit;
  final bool refreshing;

  @override
  Widget build(BuildContext context) {
    final monthLabel = cubit.monthName.trim().isNotEmpty
        ? cubit.monthName
        : cubit.monthKey;

    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Row(
        children: [
          _MonthArrowButton(
            icon: Icons.chevron_left_rounded,
            onTap: refreshing ? null : cubit.previousMonth,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 2,
                  width: 70,
                  child: refreshing
                      ? LinearProgressIndicator(
                          color: AppColors.accent,
                          backgroundColor: AppColors.border,
                        )
                      : null,
                ),
              ],
            ),
          ),
          _MonthArrowButton(
            icon: Icons.chevron_right_rounded,
            onTap: refreshing ? null : cubit.nextMonth,
          ),
        ],
      ),
    );
  }
}

class _MonthArrowButton extends StatelessWidget {
  const _MonthArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 22,
            color: onTap == null ? AppColors.textSecondary : AppColors.accent,
          ),
        ),
      ),
    );
  }
}

/// The six counters returned in `data.summary`.
class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({this.summary});

  final Summary? summary;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      StatisticsItem(
        icon: AppImages.chart,
        title: LocaleKeys.all.tr(),
        value: _formatNumber(summary?.totalSales),
        color: AppColors.mainColor,
      ),
      StatisticsItem(
        icon: AppImages.wallet,
        title: LocaleKeys.salesAmount.tr(),
        value: _formatNumber(summary?.totalSalesAmount),
        color: AppColors.blueColor,
      ),
      StatisticsItem(
        icon: AppImages.shoppingCart,
        title: LocaleKeys.productsShow.tr(),
        value: _formatNumber(summary?.displayedProducts),
        color: AppColors.yellowColor,
      ),
      StatisticsItem(
        icon: AppImages.eye,
        title: LocaleKeys.intrestedPeople.tr(),
        value: _formatNumber(summary?.interestedCount),
        color: const Color(0xffD226AC),
      ),
      StatisticsItem(
        icon: AppImages.heart,
        title: LocaleKeys.favourites.tr(),
        value: _formatNumber(summary?.favouritesCount),
        color: AppColors.redColor,
      ),
      StatisticsItem(
        icon: AppImages.bullhorn,
        title: LocaleKeys.complaints.tr(),
        value: _formatNumber(summary?.complaints),
        color: const Color(0xff387FEA),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.95,
      children: items,
    );
  }
}

/// Totals of the currently displayed period (month, or the tapped day).
class _PeriodCard extends StatelessWidget {
  const _PeriodCard({required this.cubit});

  final StatisticsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 18,
                color: AppColors.accent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  LocaleKeys.periodTotal.tr(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  cubit.periodLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PeriodValue(
                  title: LocaleKeys.salesCount.tr(),
                  value: _formatNumber(cubit.periodSalesCount),
                ),
              ),
              Container(width: 1, height: 36, color: AppColors.border),
              Expanded(
                child: _PeriodValue(
                  title: LocaleKeys.salesAmount.tr(),
                  value: _formatNumber(cubit.periodSalesAmount),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodValue extends StatelessWidget {
  const _PeriodValue({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

/// Day timeline built from `data.days`; tapping a day updates the period card
/// without hitting the network again.
class _DayTimeline extends StatelessWidget {
  const _DayTimeline({required this.cubit});

  final StatisticsCubit cubit;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final numberStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
    final labelStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w500);

    BoxDecoration decoration(Color color, {Color? border}) => BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
      border: border == null ? null : Border.all(color: border),
    );

    return EasyDateTimeLine(
      key: ValueKey(cubit.monthKey),
      initialDate: cubit.initialDate,
      locale: isArabic ? 'ar' : 'en',
      activeColor: AppColors.accent,
      headerProps: const EasyHeaderProps(showHeader: false),
      timeLineProps: const EasyTimeLineProps(hPadding: 0),
      onDateChange: cubit.selectDate,
      dayProps: EasyDayProps(
        height: 62,
        width: 54,
        borderColor: AppColors.border,
        dayStructure: DayStructure.dayStrDayNum,
        todayHighlightStyle: TodayHighlightStyle.none,
        inactiveDayStyle: DayStyle(
          decoration: decoration(AppColors.surface, border: AppColors.border),
          dayNumStyle: numberStyle.copyWith(color: AppColors.text),
          dayStrStyle: labelStyle.copyWith(color: AppColors.textSecondary),
          monthStrStyle: labelStyle.copyWith(color: AppColors.textSecondary),
        ),
        activeDayStyle: DayStyle(
          decoration: decoration(AppColors.accent),
          dayNumStyle: numberStyle.copyWith(color: AppColors.whiteColor),
          dayStrStyle: labelStyle.copyWith(color: AppColors.whiteColor),
          monthStrStyle: labelStyle.copyWith(color: AppColors.whiteColor),
        ),
        todayStyle: DayStyle(
          decoration: decoration(
            AppColors.surfaceVariant,
            border: AppColors.accent,
          ),
          dayNumStyle: numberStyle.copyWith(color: AppColors.accent),
          dayStrStyle: labelStyle.copyWith(color: AppColors.textSecondary),
          monthStrStyle: labelStyle.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

/// 2136 -> "2,136" (kept locale-independent: Latin digits work for both
/// Arabic and English users of the app).
String _formatNumber(int? value) {
  final number = value ?? 0;
  final digits = number.abs().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }

  return number < 0 ? '-$buffer' : buffer.toString();
}
