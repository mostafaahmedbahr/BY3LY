import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:by3ly/features/reportProduct/presentation/view_model/report_product_cubit.dart';
import 'package:by3ly/features/reportProduct/presentation/view_model/report_product_states.dart';

/// Radio-style reason row — tap to select, tap again toggles off.
class ReasonItemWidget extends StatelessWidget {
  const ReasonItemWidget({super.key, required this.title, required this.index});

  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportProductCubit, ReportProductStates>(
      builder: (context, state) {
        final selected = ReportProductCubit.get(context).reasonIndex == index;
        return InkWell(
          onTap: () {
            final cubit = ReportProductCubit.get(context);
            cubit.chooseReason(selected ? null : index);
          },
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.mainColor.withValues(alpha: 0.08)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.mainColor : AppColors.border,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.mainColor : Colors.transparent,
                    border: Border.all(
                      color: selected ? AppColors.mainColor : AppColors.border,
                      width: 1.6,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? AppColors.mainColor : AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
