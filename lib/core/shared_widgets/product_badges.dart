import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Product identity badges, reused everywhere a product is displayed.
//
// * Urgent      -> red pill with a bolt icon, only when `is_urgent` is true.
// * Featured    -> gold pill with a premium icon, only when rate reached 5/5.
// * Views count -> eye icon + "604 views", only when the API sends `views`.
// ---------------------------------------------------------------------------

/// A product rating of this value (or more) earns the "featured" badge.
const double kTopRatedValue = 5;

/// True when [rate] represents a full 5/5 rating.
///
/// The API sends the rate sometimes as `int`, sometimes as `String`, so both
/// are accepted here.
bool isTopRated(dynamic rate) {
  if (rate == null) return false;
  final value = rate is num
      ? rate.toDouble()
      : double.tryParse(rate.toString().trim());
  return value != null && value >= kTopRatedValue;
}

/// Small rounded label used over product images and next to titles.
class ProductBadge extends StatelessWidget {
  const ProductBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.foreground = Colors.white,
    this.fontSize = 10.5,
    this.iconSize = 12,
    this.elevated = true,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color foreground;
  final double fontSize;
  final double iconSize;

  /// Adds a soft shadow so the pill stays readable over photos.
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: foreground),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: fontSize,
              height: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Red "urgent" pill, shown only for ads flagged with `is_urgent`.
class UrgentBadge extends StatelessWidget {
  const UrgentBadge({super.key, this.elevated = true});

  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return ProductBadge(
      label: LocaleKeys.urgent.tr(),
      icon: Icons.bolt_rounded,
      color: AppColors.redColor,
      elevated: elevated,
    );
  }
}

/// Gold "featured" pill, shown only when the rating reached 5/5.
class TopRatedBadge extends StatelessWidget {
  const TopRatedBadge({super.key, this.elevated = true});

  final bool elevated;

  /// Dark brown keeps the text readable on the gold background.
  static const Color _foreground = Color(0xff3D2B00);
  static const Color _background = Color(0xffF5B301);

  @override
  Widget build(BuildContext context) {
    return ProductBadge(
      label: LocaleKeys.distinguished.tr(),
      icon: Icons.workspace_premium_rounded,
      color: _background,
      foreground: _foreground,
      elevated: elevated,
    );
  }
}

/// Shows the urgent / featured pills together, and disappears when neither is
/// relevant so cards never keep empty space.
class ProductBadges extends StatelessWidget {
  const ProductBadges({
    super.key,
    this.isUrgent = false,
    this.topRated = false,
    this.elevated = true,
    this.spacing = 6,
  });

  final bool isUrgent;
  final bool topRated;
  final bool elevated;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (!isUrgent && !topRated) return const SizedBox.shrink();
    return Wrap(
      spacing: spacing,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (isUrgent) UrgentBadge(elevated: elevated),
        if (topRated) TopRatedBadge(elevated: elevated),
      ],
    );
  }
}

/// Eye icon followed by the number of views ("604 views" / "604 مشاهدة").
///
/// Renders nothing when the count is missing or zero.
class ProductViewsLabel extends StatelessWidget {
  const ProductViewsLabel({
    super.key,
    required this.views,
    this.color,
    this.fontSize = 10.5,
    this.showZero = false,
  });

  final int? views;
  final Color? color;
  final double fontSize;
  final bool showZero;

  @override
  Widget build(BuildContext context) {
    final count = views;
    if (count == null || (!showZero && count <= 0)) {
      return const SizedBox.shrink();
    }
    final tint = color ?? AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.visibility_outlined, size: fontSize + 2.5, color: tint),
        const SizedBox(width: 3),
        Text(
          '$count ${LocaleKeys.views.tr()}',
          style: TextStyle(
            fontSize: fontSize,
            color: tint,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
