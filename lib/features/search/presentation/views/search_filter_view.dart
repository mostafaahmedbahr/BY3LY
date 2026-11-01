 import 'package:by3ly/features/search/presentation/views/search_widgets/search_filter_view_body.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors/app_colors.dart';

class SearchFilterView extends StatelessWidget {
  const SearchFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title: Text("فلتر",style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: const SearchFilterViewBody(),
    ));
  }
}
