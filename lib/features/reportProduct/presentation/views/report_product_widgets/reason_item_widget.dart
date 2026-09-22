import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_styles/app_styles.dart';
import '../../view_model/report_product_cubit.dart';
import '../../view_model/report_product_states.dart';

class ReasonItemWidget extends StatelessWidget {
  final String title;
  final int index;
  const ReasonItemWidget({super.key, required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<ReportProductCubit , ReportProductStates>(
      builder: (context , state) {
        return  InkWell(
          onTap: (){
            ReportProductCubit.get(context).chooseReason(index);
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color:  ReportProductCubit.get(context).reasonIndex == index ?
              AppColors.mainColor  : AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color:
                  ReportProductCubit.get(context).reasonIndex == index ?
                   AppColors.mainColor  :
                  const Color(0xffB6B6B6)
              ),
            ),
            child: Center(child: Text(title,
              style:
              AppStyles.textStyle14W500White.copyWith(
                color: ReportProductCubit.get(context).reasonIndex == index ?
                  AppColors.whiteColor  : const Color(0xffB6B6B6),
              ),)),
          ),
        );
      },

    );
  }
}
