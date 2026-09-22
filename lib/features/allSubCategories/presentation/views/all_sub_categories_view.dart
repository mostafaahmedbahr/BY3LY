import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/allCategories/presentation/views/all_categories_widgets/all_sub_categories_view_body.dart';
import 'package:flutter/material.dart';



class AllSubCategoriesView extends StatelessWidget {
  const AllSubCategoriesView({super.key,
    required this.mainCategoryName, required this.mainCategoryId, required this.mainCategoryImage});

  final String mainCategoryName;
  final String mainCategoryImage;
  final int mainCategoryId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Text(mainCategoryName,style: const TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold
        ),),
      ),
       body:  AllSubCategoriesViewBody(
         mainCategoryId: mainCategoryId,
         mainCategoryName: mainCategoryName.toString(),
         mainCategoryImage: mainCategoryImage.toString(),
       ),
    );
  }
}
