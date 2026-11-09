import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'source_option.dart';

/// Bottom sheet asking the user where to pick the ad images from.
Future<void> showImageSourceSheet(
  BuildContext context,
  AddNewAdCubit cubit,
) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SourceOption(
                    icon: Icons.photo_camera_outlined,
                    label: context.tr(LocaleKeys.uploadImageFromCamera),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      cubit.pickFromCamera(context);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SourceOption(
                    icon: Icons.photo_library_outlined,
                    label: context.tr(LocaleKeys.uploadImageFromGallery),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      cubit.pickImages(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
