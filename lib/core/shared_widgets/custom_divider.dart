import 'package:flutter/material.dart';
 import '../utils/app_colors/app_colors.dart';

class CustomDividerWidget extends StatelessWidget {
  const CustomDividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 2,
      color: AppColors.greyColor,
    );
  }
}
