import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

import 'all_sub_categories_widgets/all_sub_categories_view_body.dart';

class AllSubCategoriesView extends StatelessWidget {
  const AllSubCategoriesView({
    super.key,
    required this.mainCategoryName,
    required this.mainCategoryId,
    required this.mainCategoryImage,
  });

  final String mainCategoryName;
  final String mainCategoryImage;
  final int mainCategoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkMainColor,
        elevation: 0,
        surfaceTintColor: AppColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.darkMainColor,
                AppColors.mainColor,
                AppColors.secondColor,
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),
        title: Text(
          mainCategoryName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AllSubCategoriesViewBody(
        mainCategoryId: mainCategoryId,
        mainCategoryName: mainCategoryName,
        mainCategoryImage: mainCategoryImage,
      ),
    );
  }
}
