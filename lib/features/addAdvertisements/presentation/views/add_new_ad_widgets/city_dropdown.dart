import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_cubit.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_states.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_cubit.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dropdown_decoration.dart';

/// Governorate picker fed from the shared ChooseLocation cubit.
/// Listens to BOTH cubits: ChooseLocationCubit (the list itself may
/// still be loading when the form opens) and AddNewAdCubit (selection).
class CityDropdown extends StatelessWidget {
  const CityDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseLocationCubit, ChooseLocationStates>(
      builder: (context, locState) {
        final cities =
            ChooseLocationCubit.get(context).allCitiesList;
        return BlocBuilder<AddNewAdCubit, AddNewAdStates>(
          builder: (context, adState) {
            final adCubit = AddNewAdCubit.get(context);

            // Still loading → show a slim loading box, not a dead dropdown.
            if (cities.isEmpty &&
                locState is! GetAllCitiesAndCentersError) {
              return _StatusBox(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'جاري تحميل المحافظات...',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Failed to load → clear error + retry instead of silence.
            if (locState is GetAllCitiesAndCentersError) {
              return _StatusBox(
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 18, color: AppColors.redColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'تعذر تحميل المحافظات',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => ChooseLocationCubit.get(context)
                          .getAllCitiesAndCenters(),
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            return DropdownButtonFormField<int>(
              key: ValueKey('city_${adCubit.cityId}'),
              initialValue: cities
                      .map((c) => c.id)
                      .contains(adCubit.cityId)
                  ? adCubit.cityId
                  : null,
              items: cities.map((city) {
                return DropdownMenuItem<int>(
                  value: city.id,
                  child: Text(city.name ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                adCubit.selectCity(value);
              },
              decoration: dropdownDecoration(
                context.tr(LocaleKeys.city),
                prefix: const Icon(Icons.location_city_outlined,
                    color: AppColors.mainColor, size: 20),
              ),
            );
          },
        );
      },
    );
  }
}

/// Matching-height status box so the layout doesn't jump.
class _StatusBox extends StatelessWidget {
  const _StatusBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
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
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: child,
      ),
    );
  }
}
