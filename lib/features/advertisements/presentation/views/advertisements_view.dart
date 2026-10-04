  import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addAdvertisements/presentation/views/add_new_ad_view.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'advertisements_widgets/advertisements_view_body.dart';

class AdvertisementsView extends StatelessWidget {
  const AdvertisementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title: const Text("الاعلانات و الباقات",style: TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold
        ),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: const AddNewAdView(),
            ),
          );
        },
        backgroundColor: AppColors.mainColor,
        child: const Icon(Icons.add,
        color: AppColors.whiteColor,),
      ),
      body: const AdvertisementsViewBody(),
    ));
  }
}
