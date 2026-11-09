import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Premium gradient app bar for the change-password screen, matching the
/// rest of the premium surfaces in the app (dark → main → second gradient
/// with a frosted icon badge + white title).
AppBar premiumAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    iconTheme: const IconThemeData(color: Colors.white),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.darkMainColor,
            AppColors.mainColor,
            AppColors.secondColor,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
    ),
    title: Row(
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
          child: const Icon(Icons.lock_outline_rounded,
              color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            context.tr(LocaleKeys.changePassword),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ],
    ),
  );
}
