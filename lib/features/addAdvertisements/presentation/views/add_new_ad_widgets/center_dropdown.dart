import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_cubit.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_states.dart';
import 'package:by3ly/features/chooseLocation/data/models/cities_centers_model.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_cubit.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dropdown_decoration.dart';

/// Center/district picker — only the centers of the chosen governorate.
/// Listens to BOTH cubits (list may still be loading when the form opens).
class CenterDropdown extends StatelessWidget {
  const CenterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseLocationCubit, ChooseLocationStates>(
      builder: (context, locState) {
        final cities =
            ChooseLocationCubit.get(context).allCitiesList;
        return BlocBuilder<AddNewAdCubit, AddNewAdStates>(
          builder: (context, adState) {
            final adCubit = AddNewAdCubit.get(context);
            List<Centers> centers = [];
            for (final city in cities) {
              if (city.id == adCubit.cityId) {
                centers = city.centers ?? [];
                break;
              }
            }

            // Cities still loading → skeleton box, not a dead dropdown.
            if (cities.isEmpty &&
                locState is! GetAllCitiesAndCentersError) {
              return Container(
                height: 56,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.7),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'جاري تحميل المراكز...',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (adCubit.cityId == null || centers.isEmpty) {
              return DropdownButtonFormField<int>(
                items: const [],
                onChanged: null,
                decoration: dropdownDecoration(
                  context.tr(LocaleKeys.center),
                  prefix: const Icon(Icons.my_location_outlined,
                      color: AppColors.mainColor, size: 20),
                ),
              );
            }
            return DropdownButtonFormField<int>(
              key: ValueKey(
                  'center_${adCubit.cityId}_${adCubit.centerId}'),
              initialValue: centers
                      .map((c) => c.id)
                      .contains(adCubit.centerId)
                  ? adCubit.centerId
                  : null,
              items: centers.map((c) {
                return DropdownMenuItem<int>(
                  value: c.id,
                  child: Text(c.name ?? ''),
                );
              }).toList(),
              onChanged: adCubit.selectCenter,
              decoration: dropdownDecoration(
                context.tr(LocaleKeys.center),
                prefix: const Icon(Icons.my_location_outlined,
                    color: AppColors.mainColor, size: 20),
              ),
            );
          },
        );
      },
    );
  }
}
