import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:flutter/material.dart';

import '../../../../../core/routing/routes.dart';

class AddBundleButton extends StatelessWidget {
  const AddBundleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        context.pushNamed(Routes.packagesView);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.mainColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.mainColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add,color: AppColors.whiteColor,),
            ),
            const SizedBox(width: 10,),
            Text("الباقات",style: AppStyles.textStyle14W500White.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
            ),),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
