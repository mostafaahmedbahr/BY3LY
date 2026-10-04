import 'package:by3ly/core/shared_widgets/app_confirm_dialog.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/compare/presentation/view_model/compare_cubit.dart';
import 'package:by3ly/features/compare/presentation/views/compare_view_body.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CompareView extends StatelessWidget {
  const CompareView({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.tr(LocaleKeys.comparison),
      message: context.tr(LocaleKeys.clearCompareConfirm),
    );
    if (confirmed && context.mounted) {
      CompareCubit.get(context).clearBasket();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor: AppColors.mainColor,
        title: Text(
          context.tr(LocaleKeys.comparison),
          style: const TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: context.tr(LocaleKeys.clearAll),
            onPressed: () => _confirmClear(context),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: const CompareViewBody(),
    );
  }
}
