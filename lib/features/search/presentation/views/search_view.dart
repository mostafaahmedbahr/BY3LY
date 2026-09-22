 import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/search/presentation/views/search_filter_view.dart';
import 'package:by3ly/features/search/presentation/views/search_widgets/search_view_body.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../core/utils/app_colors/app_colors.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title:   Text(context.tr(LocaleKeys.search),style: const TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold
        ),),
        actions: [
         Padding(
           padding: const EdgeInsets.only(left: 20),
           child: InkWell(
               onTap: (){
                 Navigator.push(
                   context,
                   PageTransition(
                     type: PageTransitionType.rightToLeft,
                     child: const SearchFilterView(),
                   ),
                 );
               },
               child: SvgPicture.asset(AppImages.filter)),
         ),
        ],
      ),
      body: const SearchViewBody(),
    ));
  }
}
