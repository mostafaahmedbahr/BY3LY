import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Map-location inline SVG icon — same asset the app used originally.
/// Tinted white on selected (gradient) tiles, brand-tinted otherwise.
Widget _mapLocationIcon({required bool selected}) {
  return SvgPicture.asset(
    AppImages.mapLocation,
    width: 38,
    height: 38,
    colorFilter: ColorFilter.mode(
      selected ? Colors.white : AppColors.accent,
      BlendMode.srcIn,
    ),
  );
}

/// Reusable option row used by both the city and center pickers.
/// Uses the same `Map-location.svg` icon next to every name.
class LocationOptionTile extends StatelessWidget {
  const LocationOptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: selected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.mainColor,
                        AppColors.secondColor,
                      ],
                    )
                  : null,
              color: selected ? null : AppColors.surfaceVariant,
              border: Border.all(
                color: selected
                    ? AppColors.mainColor
                    : AppColors.border.withValues(alpha: 0.6),
                width: selected ? 1.4 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.mainColor
                            .withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                _mapLocationIcon(selected: selected),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? Colors.white
                          : AppColors.text,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
