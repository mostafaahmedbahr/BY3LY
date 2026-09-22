 import 'package:by3ly/features/reportProduct/presentation/views/report_product_widgets/report_the_product_view_body.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors/app_colors.dart';

class ReportTheProductView extends StatelessWidget {
  const ReportTheProductView({super.key,   this.sellerId,   this.productId});
  final int? sellerId;
  final int? productId;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title:   Text(context.tr(LocaleKeys.reportProduct),style: const TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold
        ),),
      ),
      body:   ReportTheProductViewBody(
        sellerId:sellerId ,
        productId: productId,
      ),
    ));
  }
}
