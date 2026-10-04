import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoriesListItem extends StatelessWidget {
  const CategoriesListItem(
      {super.key,
      required this.id,
      required this.image,
      required this.name});
  final int id;
  final String image;
  final String name;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(Routes.allSubCategoriesView, arguments: {
          "mainCategoryId": id,
          "mainCategoryName": name,
          "mainCategoryImage": image,
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 70,
        child: Column(
          children: [
       //     SvgPicture.asset(image,fit: BoxFit.cover,),
            CustomNetWorkImage(imageUrl: image,
              raduis: 10,
              height: 50,
              width: 60,
              fit: BoxFit.cover,
            ),
            Text(name,style: const TextStyle(
              color: AppColors.mainColor,
              fontSize: 14,
              fontWeight: FontWeight.w600
            ),),
          ],
        ),
      ),
    );
  }
}
