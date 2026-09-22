  import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/statistics/presentation/views/statistics_widgets/statistics_item.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
  import 'package:easy_date_timeline/easy_date_timeline.dart';
class StatisticsViewBody extends StatelessWidget {
  const StatisticsViewBody({super.key});

  @override
  Widget build(BuildContext context) {

    return   Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatisticsItem(
                  icon: AppImages.chart,
                  title: LocaleKeys.all.tr(),
                  value: "400",
                color: AppColors.mainColor,
              ),
              StatisticsItem(
                  icon: AppImages.shoppingCart,
                  title: LocaleKeys.productsShow.tr(),
                  value: "14",
                color: AppColors.yellowColor,
              ),
            ],
          ),
            Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatisticsItem(
                  icon: AppImages.eye,
                  title: LocaleKeys.intrestedPeople.tr(),
                  value: "400",
                  color: const Color(0xffD226AC),
                ),
                StatisticsItem(
                  icon: AppImages.bullhorn,
                  title: LocaleKeys.complaints.tr(),
                  value: "14",
                  color: const Color(0xff387FEA),
                ),
              ],
            ),
          ),
      EasyDateTimeLine(
        dayProps: const EasyDayProps(),
        initialDate: DateTime.now(),
        onDateChange: (selectedDate) {
          //`selectedDate` the new date selected.
        },
        activeColor: AppColors.mainColor,
        locale: "ar",
      ),
        ],
      ),
    );
  }
}
