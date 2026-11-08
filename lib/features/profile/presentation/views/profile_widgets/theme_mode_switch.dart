import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../main_importants.dart';
import '../../../../../core/utils/app_theme/app_theme.dart';
import 'compact_settings_tile.dart';

/// Animated light/dark theme switch — نسخة مدمجة داخل كارت الإعدادات.
class ThemeModeSwitch extends StatelessWidget {
  const ThemeModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher.withTheme(
      builder: (context, switcher, theme) {
        final isDark = theme.brightness == Brightness.dark;
        final trailing = CupertinoSwitch(
          activeTrackColor: AppColors.mainColor,
          value: isDark,
          onChanged: (value) {
            switcher.changeTheme(
              theme: value ? AppThemes.dark : AppThemes.light,
              isReversed: !value,
              onAnimationFinish: () => AppThemes.save(value),
            );
          },
        );
        return CompactSettingsTile(
          title: LocaleKeys.theme.tr(),
          iconData: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          trailing: trailing,
        );
      },
    );
  }
}
