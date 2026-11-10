import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/legalContent/data/models/legal_content_model.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'legal_content_widgets/legal_content_view_body.dart';

/// Screen for the static pages served by the API:
/// About the app / Terms & conditions / Privacy policy.
class LegalContentView extends StatelessWidget {
  const LegalContentView({super.key, required this.type});

  final LegalContentType type;

  String _title(BuildContext context) => switch (type) {
    LegalContentType.about => context.tr(LocaleKeys.aboutApp),
    LegalContentType.terms => context.tr(LocaleKeys.termsAndConditions),
    LegalContentType.privacy => context.tr(LocaleKeys.privacyPolicy),
  };

  IconData _icon() => switch (type) {
    LegalContentType.about => Icons.info_rounded,
    LegalContentType.terms => Icons.gavel_rounded,
    LegalContentType.privacy => Icons.privacy_tip_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.darkMainColor,
                AppColors.mainColor,
                AppColors.secondColor,
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
              child: Icon(
                _icon(),
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _title(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      body: LegalContentViewBody(type: type),
    );
  }
}
