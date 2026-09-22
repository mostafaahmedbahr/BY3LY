import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:flutter/material.dart';

class AddBundleButton extends StatelessWidget {
  const AddBundleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.mainColor,
        ),
        child: Row(
          children: [
            const Icon(Icons.add,color: AppColors.whiteColor,),
            const SizedBox(width: 5,),
            Text("الباقات",style: AppStyles.textStyle14W500White.copyWith(
                fontSize: 18
            ),),
          ],
        ),
      ),
    );
  }
}
