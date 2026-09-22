import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/statistics/presentation/views/statistics_widgets/statistics_view_body.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title:   Text(LocaleKeys.statistics.tr(),style: const TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: const StatisticsViewBody(),
    ));
  }
}
