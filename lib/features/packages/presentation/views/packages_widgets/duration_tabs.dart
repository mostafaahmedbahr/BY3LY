import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../view_model/packages_cubit.dart';
import '../../view_model/packages_states.dart';

/// The four duration tabs side by side: monthly / 3 / 6 / yearly.
class DurationTabs extends StatelessWidget {
  const DurationTabs({super.key});

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
            PackagesCubit.durations.length,
            (index) {
              final selected = cubit.selectedDurationIndex == index;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == 0 ? 0 : 8,
                  ),
                  child: InkWell(
                    onTap: () => cubit.changeDuration(index),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: selected
                            ? AppColors.mainColor
                            : AppColors.whiteColor,
                        border: Border.all(
                          color: selected
                              ? AppColors.mainColor
                              : const Color(0xffE3E6E9),
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
                      child: Text(
                        PackagesCubit.durations[index]['label'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: selected
                              ? AppColors.whiteColor
                              : AppColors.greyColor,
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
