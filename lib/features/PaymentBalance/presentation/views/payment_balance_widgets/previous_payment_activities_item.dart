import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PreviousPaymentActivitiesItem extends StatelessWidget {
  const PreviousPaymentActivitiesItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          const Icon(Icons.add,color: AppColors.mainColor,),
          const SizedBox(width: 20,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(context.tr(LocaleKeys.deposit),
               style: AppStyles.textStyle14W500White.copyWith(
                 color: AppColors.mainColor,
               ),),
               const Text("12/1/2024",
               style: AppStyles.textStyle10W400Gray,),
             ],
            ),
          ),
          Text("2000 ج.م",
          style: AppStyles.textStyle16W500Black.copyWith(
            color: AppColors.mainColor
          ),),
        ],
      ),
    );
  }
}
