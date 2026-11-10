import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/compare_model.dart';

/// Description card for the comparison table — side-by-side when two
/// products are picked, otherwise full-width single value.
class DescCard extends StatelessWidget {
  const DescCard({super.key, required this.first, this.second});

  final CompareProduct first;
  final CompareProduct? second;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr(LocaleKeys.descriptionLabel),
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            if (second == null)
              Text(
                _textOf(first.desc),
                textAlign: TextAlign.center,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.text,
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      _textOf(first.desc),
                      textAlign: TextAlign.center,
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: AppColors.border,
                  ),
                  Expanded(
                    child: Text(
                      _textOf(second!.desc),
                      textAlign: TextAlign.center,
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  static String _textOf(String? desc) {
    final trimmed = desc?.trim() ?? '';
    return trimmed.isEmpty ? '-' : trimmed;
  }
}
