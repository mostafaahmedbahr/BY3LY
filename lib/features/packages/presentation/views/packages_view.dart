import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors/app_colors.dart';
import 'packages_widgets/packages_view_body.dart';

class PackagesView extends StatelessWidget {
  const PackagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor: AppColors.mainColor,
        title: const Text(
          "الباقات",
          style: TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const PackagesViewBody(),
    );
  }
}
