import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';

import '../../view_model/advertisements_cubit.dart';

/// Builds the horizontally scrolling tab pills with per-tab counters.
///
/// Labels are locale keys resolved here so adding a language needs only
/// the translation entries, never this file.
class AdsTypes extends StatelessWidget {
  const AdsTypes({super.key});

  static const _labelKeys = [
    LocaleKeys.all,
    LocaleKeys.activeNow,
    LocaleKeys.inactiveAd,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementsCubit, AdvertisementsStates>(
      builder: (context, state) {
        final advertisementsCubit = AdvertisementsCubit.get(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr(LocaleKeys.myAdsTitle),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 38,
              child: ListView.separated(
                itemCount: _labelKeys.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final selected =
                      advertisementsCubit.advertisementsTypeIndex == index;
                  final count = advertisementsCubit.countForTab(index);
                  return InkWell(
                    onTap: () => advertisementsCubit
                        .setAdvertisementsTypeIndex(index),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      height: 38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: selected
                            ? AppColors.mainColor
                            : AppColors.surface,
                        border: Border.all(
                          color: selected
                              ? AppColors.mainColor
                              : AppColors.border,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: AppColors.mainColor
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.tr(_labelKeys[index]),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: selected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: selected
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: selected
                                    ? Colors.white
                                    : AppColors.mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
