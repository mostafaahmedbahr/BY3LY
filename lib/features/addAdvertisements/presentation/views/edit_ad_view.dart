import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addAdvertisements/data/repos/add_advertisements_repos_imple.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_cubit.dart';
import 'package:by3ly/features/addAdvertisements/presentation/views/add_new_ad_widgets/add_new_ad_view_body.dart';
import 'package:by3ly/features/advertisements/data/models/my_ads_data_model.dart';
import 'package:by3ly/features/allCategories/data/repositories/all_categories_repo_imple.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/cubit.dart';
import 'package:by3ly/features/allSubCategories/data/repos/all_sub_categories_repos_imple.dart';
import 'package:by3ly/features/allSubCategories/presentation/view_model/all_sub_categories_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditAdView extends StatelessWidget {
  const EditAdView({super.key, required this.ad});

  final Ads ad;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AddNewAdCubit(getIt.get<AddAdvertisementsRepoImpl>()),
        ),
        BlocProvider(
          create: (context) =>
              AllCategoriesCubit(getIt.get<AllCategoriesRepoImpl>())
                ..getAllCategories(),
        ),
        BlocProvider(
          create: (context) => AllSubCategoriesCubit(
              getIt.get<AllSubCategoriesRepoImpl>()),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          shadowColor: AppColors.mainColor,
          surfaceTintColor: AppColors.mainColor,
          title: Text(
            context.tr(LocaleKeys.editAd),
            style: const TextStyle(
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: AddNewAdViewBody(adToEdit: ad),
      ),
    );
  }
}
