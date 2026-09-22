 import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors/app_colors.dart';
import 'help_support_widgets/help_support_view_body.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title:   Text(LocaleKeys.helpAndSupport.tr(),style: const TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: const HelpSupportViewBody(),
    ));
  }
}
