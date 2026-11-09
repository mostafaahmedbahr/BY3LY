import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_cubit.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_states.dart';
import 'package:by3ly/features/allSubCategories/presentation/view_model/all_sub_categories_cubit.dart';
import 'package:by3ly/features/allSubCategories/presentation/view_model/all_sub_categories_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dropdown_decoration.dart';

/// Dependent sub-category picker. Disabled until a top-level category is
/// chosen; shows a spinner while its list is loading.
class SubCategoryDropdown extends StatelessWidget {
  const SubCategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewAdCubit, AddNewAdStates>(
      builder: (context, adState) {
        final adCubit = AddNewAdCubit.get(context);
        if (adCubit.categoryId == null) {
          return DropdownButtonFormField<int>(
            items: const [],
            onChanged: null,
            decoration: dropdownDecoration(
              context.tr(LocaleKeys.subCategory),
              prefix: const Icon(Icons.account_tree_outlined,
                  color: AppColors.mainColor, size: 20),
            ),
          );
        }
        return BlocBuilder<AllSubCategoriesCubit,
            AllSubCategoriesStates>(
          builder: (context, state) {
            if (state is GetAllSubCategoriesLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            final subs = AllSubCategoriesCubit.get(context)
                    .allSubCategoriesModel
                    ?.data
                    ?.subCategories ??
                [];
            // Guard: a stale subCategoryId (e.g. category just changed
            // and the new list hasn't arrived) crashes the dropdown.
            final subIds = subs.map((s) => s.id).toSet();
            final safeSub = subIds.contains(adCubit.subCategoryId)
                ? adCubit.subCategoryId
                : null;
            return DropdownButtonFormField<int>(
              key: ValueKey(
                  'sub_${adCubit.categoryId}_$safeSub'),
              initialValue: safeSub,
              items: subs.map((s) {
                return DropdownMenuItem<int>(
                  value: s.id,
                  child: Text(s.name ?? ''),
                );
              }).toList(),
              onChanged: adCubit.selectSubCategory,
              decoration: dropdownDecoration(
                context.tr(LocaleKeys.subCategory),
                prefix: const Icon(Icons.account_tree_outlined,
                    color: AppColors.mainColor, size: 20),
              ),
            );
          },
        );
      },
    );
  }
}
