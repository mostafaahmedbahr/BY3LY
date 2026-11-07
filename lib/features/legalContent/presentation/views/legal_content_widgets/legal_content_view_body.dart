import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/features/legalContent/data/models/legal_content_model.dart';
import 'package:by3ly/features/legalContent/data/repos/legal_content_repos_imple.dart';
import 'package:by3ly/features/legalContent/presentation/view_model/legal_content_cubit.dart';
import 'package:by3ly/features/legalContent/presentation/view_model/legal_content_states.dart';
import 'package:by3ly/main_importants.dart';
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
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: 6,
              itemBuilder: (context, _) =>
                  const SimmerLoading(height: 60, raduis: 12),
              separatorBuilder: (context, _) => const SizedBox(height: 12),
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
            textDirection: (data?.isRtl ?? true)
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: RefreshIndicator(
              color: AppColors.accent,
              backgroundColor: AppColors.surface,
              onRefresh: () => cubit.getLegalContent(type),
              child: ListView(
                // Always allow the drag, even when the content fits on screen.
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
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
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      style: {
                        "body": Style(
                          fontSize: FontSize(14),
                          lineHeight: const LineHeight(1.8),
                          color: AppColors.text,
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                        "h1": Style(
                          fontSize: FontSize(20),
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainColor,
                        ),
                        "h2": Style(
                          fontSize: FontSize(18),
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainColor,
                        ),
                        "h3": Style(
                          fontSize: FontSize(16),
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                        "p": Style(
                          fontSize: FontSize(14),
                          lineHeight: const LineHeight(1.8),
                        ),
                        "a": Style(
                          color: AppColors.mainColor,
                          textDecoration: TextDecoration.underline,
                        ),
                        "li": Style(
                          fontSize: FontSize(14),
                          lineHeight: const LineHeight(1.8),
                        ),
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
