import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/advertisements/data/models/my_ads_data_model.dart';
import 'package:by3ly/features/advertisements/data/repos/advertisements_repos_imple.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_cubit.dart';
import 'package:by3ly/features/advertisements/presentation/views/ad_details_widgets/ad_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdDetailsView extends StatelessWidget {
  const AdDetailsView({super.key, required this.ad});

  final Ads ad;

  @override
  Widget build(BuildContext context) {
    // Local provider: pushed routes can't see AdvertisementsView's cubit.
    return BlocProvider(
      create: (context) => AdvertisementsCubit(
          getIt.get<AdvertisementsRepoImpl>()),
      child: Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor: AppColors.mainColor,
        title: Text(
          ad.name ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AdDetailsViewBody(ad: ad),
    ));
  }
}
