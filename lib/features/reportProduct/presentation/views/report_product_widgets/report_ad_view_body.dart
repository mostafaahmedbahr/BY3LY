import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/features/reportProduct/presentation/view_model/report_product_cubit.dart';
import 'package:by3ly/features/reportProduct/presentation/view_model/report_product_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Report-ad flow used from product/ad details:
/// pick a reason (from the reportReasons endpoint) + write a
/// description, then POST reportAd {seller_id, product_id, reason,
/// description}.
class ReportAdViewBody extends StatefulWidget {
  const ReportAdViewBody(
      {super.key, required this.sellerId, required this.productId});

  final int sellerId;
  final int productId;

  @override
  State<ReportAdViewBody> createState() => _ReportAdViewBodyState();
}

class _ReportAdViewBodyState extends State<ReportAdViewBody> {
  @override
  void initState() {
    super.initState();
    ReportProductCubit.get(context).getReportReasons();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportProductCubit, ReportProductStates>(
      listener: (context, state) {
        if (state is ReportAdSuccess) {
          final msg = state.message?.trim();
          Toast.showSuccessToast(
            msg: (msg != null && msg.isNotEmpty)
                ? msg
                : context.tr(LocaleKeys.reportSent),
            context: context,
          );
          Navigator.pop(context, true);
        } else if (state is ReportAdError) {
          final msg = state.message == 'selectReason'
              ? context.tr(LocaleKeys.pleaseSelectReason)
              : state.message;
          Toast.showErrorToast(msg: msg, context: context);
        }
      },
      builder: (context, state) {
        final cubit = ReportProductCubit.get(context);

        if (state is GetReportReasonsLoading &&
            cubit.reportReasons.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SimmerLoading(height: 26, raduis: 8),
                SizedBox(height: 14),
                SimmerLoading(height: 14, width: 180, raduis: 8),
                SizedBox(height: 18),
                SimmerLoading(height: 50, raduis: 14),
                SizedBox(height: 10),
                SimmerLoading(height: 50, raduis: 14),
                SizedBox(height: 10),
                SimmerLoading(height: 50, raduis: 14),
                SizedBox(height: 10),
                SimmerLoading(height: 50, raduis: 14),
              ],
            ),
          );
        }
        if (state is GetReportReasonsError &&
            cubit.reportReasons.isEmpty) {
          return CustomErrorWidget(
            error: state.message,
            onTap: () => cubit.getReportReasons(),
          );
        }

        final reasons = cubit.reportReasons;
        final submitting = state is ReportAdLoading;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text(
                context.tr(LocaleKeys.reasonForReport),
                style: AppStyles.textStyle16W600Black.copyWith(
                  fontSize: 20,
                ),
              ),
              const CustomSizedBox(height: 10),
              Text(
                context.tr(LocaleKeys.selectReason),
                style: AppStyles.textStyle12W600Gary,
              ),
              const CustomSizedBox(height: 16),
              if (reasons.isEmpty)
                Text(
                  '-',
                  style: TextStyle(color: AppColors.textSecondary),
                )
              else
                ...reasons.where((r) => (r.id ?? '').isNotEmpty).map((reason) {
                  final key = reason.id!;
                  final selected =
                      cubit.selectedReasonKey == key;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () =>
                          cubit.selectReportReason(key),
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.mainColor
                                  .withValues(alpha: 0.07)
                              : AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? AppColors.mainColor
                                : AppColors.border,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                reason.name ?? key,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: selected
                                      ? AppColors.mainColor
                                      : AppColors.text,
                                ),
                              ),
                            ),
                            Container(
                              height: 22,
                              width: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selected
                                    ? AppColors.mainColor
                                    : Colors.transparent,
                                border: Border.all(
                                  color: selected
                                      ? AppColors.mainColor
                                      : AppColors.border,
                                  width: 1.5,
                                ),
                              ),
                              child: selected
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              const CustomSizedBox(height: 16),
              Text(
                context.tr(LocaleKeys.notes),
                style: AppStyles.textStyle16W600Black,
              ),
              const CustomSizedBox(height: 12),
              CustomTextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                hintText: context.tr(LocaleKeys.writeReasonForReport),
                controller: cubit.reportDescCon,
              ),
              const CustomSizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.yellowColor,
                        Color(0xffE08B1B),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color:
                            AppColors.yellowColor.withValues(alpha: 0.40),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: submitting
                          ? null
                          : () {
                        if (cubit.selectedReasonKey == null) {
                          Toast.showErrorToast(
                            msg: context.tr(LocaleKeys.pleaseSelectReason),
                            context: context,
                          );
                          return;
                        }
                        cubit.submitReportAd(
                          sellerId: widget.sellerId,
                          productId: widget.productId,
                        );
                      },
                      child: Center(
                        child: submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Color(0xff1A1205),
                                ),
                              )
                            : Text(
                                context.tr(LocaleKeys.send),
                                style: const TextStyle(
                                  color: Color(0xff1A1205),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.1,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
