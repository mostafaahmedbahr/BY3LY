import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../main_importants.dart';
import '../../../../../core/utils/app_theme/app_theme.dart';

/// Animated light/dark theme switch shown in the profile settings.
class ThemeModeSwitch extends StatelessWidget {
  const ThemeModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher.withTheme(
      builder: (context, switcher, theme) {
        final isDark = theme.brightness == Brightness.dark;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 4),
          child: Card(
            margin: EdgeInsets.zero,
            shadowColor: AppColors.mainColor,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              height: 56,
              child: Row(
                children: [
                  Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color:  isDark ? AppColors.whiteColor : AppColors.blackColor,
                  ),
                  Gap(18.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.theme.tr(),
                        style: AppStyles.textStyle14W500White.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        isDark
                            ? LocaleKeys.darkMode.tr()
                            : LocaleKeys.lightMode.tr(),
                        style: AppStyles.textStyle10W400Gray,
                      ),
                    ],
                  ),
                  const Spacer(),
                  CupertinoSwitch(
                    activeTrackColor: AppColors.mainColor,
                    value: isDark,
                    onChanged: (value) {
                      switcher.changeTheme(
                        theme: value ? AppThemes.dark : AppThemes.light,
                        isReversed: !value,
                        onAnimationFinish: () => AppThemes.save(value),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
