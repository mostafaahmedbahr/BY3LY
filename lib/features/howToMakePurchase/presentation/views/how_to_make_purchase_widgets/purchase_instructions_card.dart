import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/howToMakePurchase/data/models/how_to_make_purchase_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

/// Server-rendered HTML instructions rendered as a white bordered card —
/// HTML kept verbatim, text direction driven by the server payload.
class PurchaseInstructionsCard extends StatelessWidget {
  const PurchaseInstructionsCard({super.key, required this.data});

  final Data data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((data.title?.trim().isNotEmpty ?? false)) ...[
            Text(
              data.title!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.mainColor,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),
          ],
          Html(
            data: data.html ?? '',
            style: {
              'body': Style(
                fontSize: FontSize(14),
                lineHeight: const LineHeight(1.8),
                color: AppColors.text,
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
              'h1': Style(
                fontSize: FontSize(20),
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor,
              ),
              'h2': Style(
                fontSize: FontSize(18),
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor,
              ),
              'h3': Style(
                fontSize: FontSize(16),
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
              'li': Style(
                fontSize: FontSize(14),
                lineHeight: const LineHeight(1.8),
              ),
              'strong': Style(
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
              'a': Style(
                color: AppColors.mainColor,
                textDecoration: TextDecoration.underline,
              ),
              'hr': Style(
                color: AppColors.border,
              ),
            },
          ),
        ],
      ),
    );
  }
}
