import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/features/PaymentBalance/presentation/views/payment_balance_widgets/previous_payment_activities_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../lang/locale_keys.dart';
import '../../../../addBalance/presentation/views/add_balance_view.dart';

class PaymentAndBalanceViewBody extends StatelessWidget {
  const PaymentAndBalanceViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.mainColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.tr(LocaleKeys.balance),style: AppStyles.textStyle14W500White,),
                    IconButton(onPressed: (){},
                        icon: const Icon(Icons.refresh,
                        color: AppColors.yellowColor,)
                    ),
                  ],
                ),
                Text("12,000 ج.م",
                style: AppStyles.textStyle14W500White.copyWith(
                  fontSize: 24,
                ),),
              ],
            ),
          ),
            Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(context.tr(LocaleKeys.previousActivities),style: AppStyles.textStyle16W500Black,),
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context , index ){
                  return const PreviousPaymentActivitiesItem();
                },
                separatorBuilder: (context , index ){
                  return  const CustomSizedBox(height: 40,);
                },
                itemCount: 15,
            ),
          ),
          const CustomSizedBox(height: 20,),
          CustomButton(
            btnText: Text(context.tr(LocaleKeys.addCredit),
              style: AppStyles.textStyle16W600Black.copyWith(
                color: AppColors.whiteColor,
              ),),
            onPressed: (){
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const AddBalanceView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
