import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/features/howToMakePurchase/data/repos/how_to_make_purchase_repos_imple.dart';
import 'package:by3ly/features/howToMakePurchase/presentation/view_model/how_to_make_purchase_cubit.dart';
import 'package:by3ly/features/howToMakePurchase/presentation/view_model/how_to_make_purchase_states.dart';
import 'package:by3ly/main_importants.dart';
import 'package:flutter_html/flutter_html.dart';

class HowToMakePurchaseViewBody extends StatelessWidget {
  const HowToMakePurchaseViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HowToMakePurchaseCubit(
          getIt.get<HowToMakePurchaseRepoImpl>())
        ..getHowToMakePurchaseData(),
      child: BlocBuilder<HowToMakePurchaseCubit,
          HowToMakePurchaseStates>(
        builder: (context, state) {
          final cubit = HowToMakePurchaseCubit.get(context);

          if (state is GetHowToMakePurchaseDataLoadingState &&
              cubit.howToMakePurchaseModel?.data?.html == null) {
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: 5,
            itemBuilder: (context, _) =>
                const SimmerLoading(height: 60, raduis: 12),
            separatorBuilder: (context, _) =>
                const SizedBox(height: 12),
            );
          }

          if (state is GetHowToMakePurchaseDataErrorState &&
              cubit.howToMakePurchaseModel?.data?.html == null) {
            return CustomErrorWidget(
              error: state.error,
              onTap: () =>
                  cubit.getHowToMakePurchaseData(),
            );
          }

          final data = cubit.howToMakePurchaseModel?.data;
          final isRtl = (data?.direction ?? 'rtl') != 'ltr';

          return Directionality(
            textDirection:
                isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if ((data?.title?.trim().isNotEmpty ?? false))
                  Text(
                    data!.title!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.mainColor,
                      height: 1.4,
                    ),
                  ),
                if ((data?.title?.trim().isNotEmpty ?? false))
                  const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: const Color(0xFFF0F0F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Html(
                    data: data?.html ?? '',
                    style: {
                      "body": Style(
                        fontSize: FontSize(14),
                        lineHeight: const LineHeight(1.8),
                        color: const Color(0xff1F2937),
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
                        color: const Color(0xff1F2937),
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
          );
        },
      ),
    );
  }
}
