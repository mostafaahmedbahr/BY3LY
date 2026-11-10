import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/last_updated_label.dart';
import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/legalContent/data/models/legal_content_model.dart';
import 'package:by3ly/features/legalContent/data/repos/legal_content_repos_imple.dart';
import 'package:by3ly/features/legalContent/presentation/view_model/legal_content_cubit.dart';
import 'package:by3ly/features/legalContent/presentation/view_model/legal_content_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

/// Body of the About / Terms / Privacy pages: shimmer while loading,
/// error with retry, otherwise the HTML coming from the API.
class LegalContentViewBody extends StatelessWidget {
  const LegalContentViewBody({super.key, required this.type});

  final LegalContentType type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LegalContentCubit(
        getIt.get<LegalContentRepoImpl>(),
      )..getLegalContent(type),
      child: BlocBuilder<LegalContentCubit, LegalContentStates>(
        builder: (context, state) {
          final cubit = LegalContentCubit.get(context);

          if (state is GetLegalContentLoadingState &&
              cubit.legalContentModel == null) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: const [
                SimmerLoading(height: 44, raduis: 10),
                SizedBox(height: 12),
                SimmerLoading(height: 110, raduis: 16),
                SizedBox(height: 12),
                SimmerLoading(height: 110, raduis: 16),
                SizedBox(height: 12),
                SimmerLoading(height: 44, raduis: 16),
              ],
            );
          }

          if (state is GetLegalContentErrorState &&
              cubit.legalContentModel == null) {
            return CustomErrorWidget(
              error: state.error,
              onTap: () => cubit.getLegalContent(type),
            );
          }

          final data = cubit.legalContentModel?.data;

          // The page title lives in the app bar and the HTML starts with its
          // own heading, so only the body is rendered here.
          return Directionality(
            textDirection:
                (data?.isRtl ?? true) ? TextDirection.rtl : TextDirection.ltr,
            child: RefreshIndicator(
              color: AppColors.accent,
              backgroundColor: AppColors.surface,
              onRefresh: () => cubit.getLegalContent(type),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                children: [
                  Container(
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
                    child: Html(
                      data: data?.content ?? '',
                      // Links inside the page open in the browser.
                      onLinkTap: (url, attributes, element) async {
                        if (url == null || url.trim().isEmpty) return;
                        final uri = Uri.tryParse(url);
                        if (uri == null) return;
                        try {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {
                          debugPrint('LegalContentViewBody: link tap failed — $e');
                        }
                      },
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
                        'p': Style(
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
                        'li': Style(
                          fontSize: FontSize(14),
                          lineHeight: const LineHeight(1.8),
                        ),
                      },
                    ),
                  ),
                  if (data?.updatedAt != null &&
                      (data!.updatedAt?.trim().isNotEmpty ?? false)) ...[
                    const SizedBox(height: 16),
                    LastUpdatedLabel(
                      rawUpdatedAt: data.updatedAt,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
