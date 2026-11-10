import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

import 'spec_row_data.dart';

/// White spec table: label, then side-by-side values (or full-width when
/// only one product remains). Price row is highlighted in brand color.
class SpecCard extends StatelessWidget {
  const SpecCard({super.key, required this.rows});

  final List<SpecRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                children: [
                  Text(
                    rows[i].label,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (rows[i].second.isEmpty)
                    Text(
                      rows[i].first,
                      textAlign: TextAlign.center,
                      style: _cellStyle(rows[i]),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            rows[i].first,
                            textAlign: TextAlign.center,
                            style: _cellStyle(rows[i]),
                          ),
                        ),
                        Container(width: 1, height: 20, color: AppColors.border),
                        Expanded(
                          child: Text(
                            rows[i].second,
                            textAlign: TextAlign.center,
                            style: _cellStyle(rows[i]),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (i != rows.length - 1)
              Divider(height: 1, color: AppColors.border),
          ],
        ],
      ),
    );
  }

  TextStyle _cellStyle(SpecRowData row) {
    if (row.highlight) {
      return TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.mainColor,
        decoration:
            row.strikethrough ? TextDecoration.lineThrough : TextDecoration.none,
      );
    }
    if (row.strikethrough) {
      return TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
        decoration: TextDecoration.lineThrough,
      );
    }
    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: AppColors.text,
    );
  }
}
