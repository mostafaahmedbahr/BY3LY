import 'package:auto_size_text/auto_size_text.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Colored summary card used at the top of the statistics screen.
///
/// It fills the width given by its parent (a grid cell), so the layout adapts
/// to every screen size.
class StatisticsItem extends StatelessWidget {
  const StatisticsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final String icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: AutoSizeText(
                  title,
                  style: AppStyles.textStyle14W500White,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: AutoSizeText(
                value,
                style: AppStyles.textStyle16W500Black.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
