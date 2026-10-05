  import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:by3ly/features/addAdvertisements/presentation/views/add_new_ad_view.dart';
import 'package:by3ly/features/advertisements/data/repos/advertisements_repos_imple.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'advertisements_widgets/advertisements_view_body.dart';

class AdvertisementsView extends StatelessWidget {
  const AdvertisementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdvertisementsCubit(
          getIt.get<AdvertisementsRepoImpl>())..getAllMyAdsDataMethod(type: 0),
      child: SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title: const Text("الاعلانات و الباقات",style: TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold
        ),),
      ),
      floatingActionButton: Builder(
        builder: (fabContext) {
          return FloatingActionButton(
            onPressed: () async {
              if (!await GuestGuard.requireLogin(fabContext)) return;
              if (!fabContext.mounted) return;
              final created = await Navigator.push(
                fabContext,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const AddNewAdView(),
                ),
              );
              // Refresh the list so the newly published ad appears.
              if (created == true && fabContext.mounted) {
                fabContext
                    .read<AdvertisementsCubit>()
                    .getAllMyAdsDataMethod(type: 0);
              }
            },
            backgroundColor: AppColors.mainColor,
            child: const Icon(Icons.add,
              color: AppColors.whiteColor,),
          );
        },
      ),
      body: const AdvertisementsViewBody(),
      )),
    );
  }
}
