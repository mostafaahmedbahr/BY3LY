
 import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_colors/app_colors.dart';
import '../utils/app_images/app_images.dart';
import 'custom_sized_box.dart';

//ignore: must_be_immutable
class CustomErrorWidget extends StatelessWidget {
    CustomErrorWidget({super.key , required this.onTap, this.error});
  void Function()? onTap;
  final String? error;
  @override
  Widget build(BuildContext context) {
    return   Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImages.serverErrorImage,),
          const CustomSizedBox(height: 10,),
          InkWell(
              onTap: onTap,
              child:   Text(error ?? "Server Error , Please Try Again !!",
              style: const TextStyle(
                color: AppColors.mainColor,
              ),),),
        ],
      ),
    );
  }
}
