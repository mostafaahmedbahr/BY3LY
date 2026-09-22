import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

import 'all_categories_widgets/all_categories_view_body.dart';

class AllCategoriesView extends StatelessWidget {
  const AllCategoriesView({super.key,});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("جميع الفئات",style: TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold
        ),),
      ),
      body:   const AllCategoriesViewBody(),
    );
  }
}
