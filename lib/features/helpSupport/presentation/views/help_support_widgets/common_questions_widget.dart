import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CommonQuestionsWidget extends StatelessWidget {
  const CommonQuestionsWidget({super.key});

  static const _faqs = [
    (LocaleKeys.howBuyOperationDone, LocaleKeys.howBuyOperationDoneAnswer),
    (LocaleKeys.howIsTheSaleProcess, LocaleKeys.howIsTheSaleProcessAnswer),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            context.tr(LocaleKeys.commonQuestions),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 0.4,
            ),
          ),
        ),
        for (final (question, answer) in _faqs)
          _FaqTile(
            question: context.tr(question),
            answer: context.tr(answer),
          ),
      ],
    );
  }
}

/// Lightweight FAQ tile: hairline-bordered card whose answer expands
/// in place — replaces the old expansion_tile_card dependency.
class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          expandedAlignment: Alignment.topLeft,
          iconColor: AppColors.mainColor,
          collapsedIconColor: AppColors.textSecondary,
          shape: const Border(),
          collapsedShape: const Border(),
          title: Text(
            question,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          children: [
            Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 10),
            Text(
              answer,
              style: TextStyle(
                fontSize: 12,
                height: 1.65,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
