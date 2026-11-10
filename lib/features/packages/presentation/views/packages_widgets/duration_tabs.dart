import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/packages_cubit.dart';
import '../../view_model/packages_states.dart';

/// The four duration tabs side by side: monthly / 3 / 6 / yearly.
class DurationTabs extends StatelessWidget {
  const DurationTabs({super.key});

  String _labelFor(int index, BuildContext context) {
    switch (index) {
      case 0:
        return context.tr(LocaleKeys.monthly);
      case 1:
        return context.tr(LocaleKeys.threeMonths);
      case 2:
        return context.tr(LocaleKeys.sixMonths);
      case 3:
        return context.tr(LocaleKeys.yearly);
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackagesCubit, PackagesStates>(
      buildWhen: (previous, current) =>
          current is PackagesDurationChangedState ||
          current is GetPackagesSuccessState,
      builder: (context, state) {
        final cubit = PackagesCubit.get(context);
        return Row(
          children: List.generate(
            PackagesCubit.durationMonths.length,
            (index) {
              final selected = cubit.selectedDurationIndex == index;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == 0 ? 0 : 8),
                  child: InkWell(
                    onTap: () => cubit.changeDuration(index),
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
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
                                      .withValues(alpha: 0.30),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        _labelFor(index, context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: selected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
