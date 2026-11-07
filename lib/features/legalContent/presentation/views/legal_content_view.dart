import 'package:by3ly/features/legalContent/data/models/legal_content_model.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        shadowColor: AppColors.mainColor,
        surfaceTintColor: AppColors.mainColor,
        title: Text(
          _title(context),
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: LegalContentViewBody(type: type),
    );
  }
}
