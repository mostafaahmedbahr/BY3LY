import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors/app_colors.dart';
import 'fav_widgets/fav_view_body.dart';

class FavView extends StatelessWidget {
  const FavView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title:   Text(context.tr(LocaleKeys.favoriteAds),style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: const FavViewBody(),
    ));
  }
}
