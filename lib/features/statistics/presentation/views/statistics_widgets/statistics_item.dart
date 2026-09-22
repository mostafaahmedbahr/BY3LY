import 'package:auto_size_text/auto_size_text.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      padding: const EdgeInsets.all(10),
      height: 74,
      width: 165,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
               colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
               ),

              ),
              const SizedBox(width: 5),
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
            child: AutoSizeText(
              value,
              style: AppStyles.textStyle16W500Black.copyWith(
                color: AppColors.whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
