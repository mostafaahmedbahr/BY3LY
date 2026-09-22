 import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

import 'notifications_widgets/notifications_view_body.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title: const Text("الاشعارات",style: TextStyle(
          color: AppColors.mainColor,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: const NotificationsViewBody(),
    ));
  }
}
