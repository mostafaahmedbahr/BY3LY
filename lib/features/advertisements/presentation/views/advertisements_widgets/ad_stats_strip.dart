import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:by3ly/core/utils/app_colors/app_colors.dart';

/// Compact stats row shared by the ad card (list) and the ad details page:
/// rating, comments and reviews in three tinted cells with dividers.
class AdStatsStrip extends StatelessWidget {
  const AdStatsStrip({
    super.key,
    required this.rate,
    required this.comments,
    required this.reviews,
  });

  final int rate;
  final int comments;
  final int reviews;

  static const _icons = [
    Icons.star_rounded,
    Icons.chat_bubble_outline_rounded,
    Icons.remove_red_eye_outlined,
  ];

  static const _tints = [
    Color(0xffFFF4D6),
    Color(0xffE3F2FD),
    Color(0xffE6F4EF),
  ];

  @override
  Widget build(BuildContext context) {
    final values = [rate, comments, reviews];
    final labels = [
      context.tr(LocaleKeys.ratingLabel),
      context.tr(LocaleKeys.commentsLabel),
      context.tr(LocaleKeys.reviewsLabel),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (int i = 0; i < 3; i++) ...[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: _tints[i],
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      _icons[i],
                      size: 16,
                      color: const Color(0xff1F2937),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${values[i]}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          labels[i],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (i != 2)
              Container(width: 1, height: 32, color: AppColors.border),
          ],
        ],
      ),
    );
  }
}
