import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'all_sub_categories_products_widgets/all_sub_categories_products_view_body.dart';

class AllSubCategoriesProductsView extends StatelessWidget {
  const AllSubCategoriesProductsView(
      {super.key, required this.subCategoryId, required this.subCategoryName});

  final int subCategoryId;
  final String subCategoryName;

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
          "${context.tr(LocaleKeys.allProducts)} ( $subCategoryName )",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AllSubCategoriesProductsViewBody(
        subCategoryId: subCategoryId,
      ),
    );
  }
}
