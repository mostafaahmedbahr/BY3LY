import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/statistics/data/repos/statistics_repos_imple.dart';
import 'package:by3ly/features/statistics/presentation/view_model/statistics_cubit.dart';
import 'package:by3ly/features/statistics/presentation/views/statistics_widgets/statistics_view_body.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StatisticsCubit(getIt.get<StatisticsRepoImpl>())..getStatistics(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          shadowColor: AppColors.mainColor,
          surfaceTintColor: AppColors.mainColor,
          title: Text(
            LocaleKeys.statistics.tr(),
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const StatisticsViewBody(),
      ),
    );
  }
}
