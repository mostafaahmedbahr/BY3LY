import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Selected location summary card: Map-location icon + "change" action.
/// Shared between the governorate and center pickers.
class SelectedLocationCard extends StatelessWidget {
  const SelectedLocationCard({
    super.key,
    required this.label,
    required this.onChange,
  });

  final String label;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: const Alignment(-0.9, -0.9),
          end: const Alignment(0.9, 0.9),
          colors: [
            AppColors.mainColor.withValues(alpha: 0.18),
            AppColors.secondColor.withValues(alpha: 0.18),
          ],
        ),
        border: Border.all(
          color: AppColors.mainColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(
                  AppImages.mapLocation,
                  width: 34,
                  height: 34,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ).copyWith(color: AppColors.accent),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onChange,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Text(
                    context.tr(LocaleKeys.change),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.edit_outlined,
                      color: AppColors.textSecondary, size: 17),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
