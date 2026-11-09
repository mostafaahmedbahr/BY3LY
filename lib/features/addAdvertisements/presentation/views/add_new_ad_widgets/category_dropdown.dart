import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_cubit.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_states.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/cubit.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/states.dart';
import 'package:by3ly/features/allSubCategories/presentation/view_model/all_sub_categories_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dropdown_decoration.dart';

/// Top-level category picker. Picking one resets the sub-category and
/// re-fetches the matching sub-categories.
class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewAdCubit, AddNewAdStates>(
      builder: (context, adState) {
        final adCubit = AddNewAdCubit.get(context);
        return BlocBuilder<AllCategoriesCubit, AllCategoriesStates>(
          builder: (context, state) {
            if (state is GetAllCategoriesLoading) {
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
            final categories = context
                    .read<AllCategoriesCubit>()
                    .allCategoriesModel
                    ?.data
                    ?.categories ??
                [];
            // Guard: passing a value that is not in items crashes
            // DropdownButtonFormField (assertion). Fall back to null.
            final catIds = categories.map((c) => c.id).toSet();
            final safeCat =
                catIds.contains(adCubit.categoryId) ? adCubit.categoryId : null;
            return DropdownButtonFormField<int>(
              key: ValueKey('cat_$safeCat'),
              initialValue: safeCat,
              items: categories.map((c) {
                return DropdownMenuItem<int>(
                  value: c.id,
                  child: Text(c.name ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                adCubit.selectCategory(value);
                AllSubCategoriesCubit.get(context)
                    .getAllSubCategories(categoryId: value);
              },
              decoration: dropdownDecoration(
                context.tr(LocaleKeys.category),
                prefix: const Icon(Icons.grid_view_rounded,
                    color: AppColors.mainColor, size: 20),
              ),
            );
          },
        );
      },
    );
  }
}
