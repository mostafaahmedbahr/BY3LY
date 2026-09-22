 import 'package:by3ly/features/search/presentation/views/search_widgets/search_filter_view_body.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors/app_colors.dart';

class SearchFilterView extends StatelessWidget {
  const SearchFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title: const Text("فلتر",style: TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: const SearchFilterViewBody(),
    ));
  }
}
