import 'package:by3ly/main_importants.dart';

/// صف مدمج داخل كارت الإعدادات المجمع.
///
/// تصميم [CompactSettingsTile]:
/// - الارتفاع 48 (بدل 56 + Padding 5 في التصميم القديم = 66 لكل عنصر)
/// - عنوان فقط بدون subtitle -> شكل أنظف وصفحه أقصر
/// - الأيقونة داخل مربع 36x36 خلفيته tint من اللون الرئيسي
/// - السهم يتقلب تلقائياً في RTL/LTR حسب الاتجاه
class CompactSettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  /// مصدر الأيقونة: إما IconData أو مسار صورة (svg/png)
  final IconData? iconData;
  final String? imagePath;

  /// لون الأيقونة والخلفية — افتراضياً أخضر (AppColors.mainColor)
  final Color? tintColor;

  /// trailing مخصص (مثل Switch) — لو null يُعرض سهم
  final Widget? trailing;

  const CompactSettingsTile({
    super.key,
    required this.title,
    this.onTap,
    this.iconData,
    this.imagePath,
    this.tintColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final color = tintColor ?? AppColors.mainColor;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildIconBox(context, color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.textStyle14W500Black.copyWith(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailing != null)
                  trailing!
                else
                  Icon(
                    isRtl
                        ? Icons.arrow_back_ios_rounded
                        : Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconBox(BuildContext context, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Widget icon;

    if (imagePath != null && imagePath!.isNotEmpty) {
      if (imagePath!.endsWith('.svg')) {
        icon = SvgPicture.asset(
          imagePath!,
          width: 19,
          height: 19,
          colorFilter: ColorFilter.mode(
            isDark ? AppColors.whiteColor : color,
            BlendMode.srcIn,
          ),
        );
      } else {
        // png (مثلاً: اللغة)
        icon = Image.asset(
          imagePath!,
          width: 19,
          height: 19,
          color: isDark ? AppColors.whiteColor : color,
        );
      }
    } else {
      icon = Icon(
        iconData ?? Icons.settings_rounded,
        size: 19,
        color: isDark ? AppColors.whiteColor : color,
      );
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.mainColor.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: icon,
    );
  }
}

/// فاصل رفيع بين صفوف كارت الإعدادات
class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.7,
      indent: 60,
      endIndent: 12,
      color: AppColors.border,
    );
  }
}
