import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/features/reportProduct/presentation/view_model/report_product_cubit.dart';
import 'package:by3ly/features/reportProduct/presentation/view_model/report_product_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:cherry_toast/cherry_toast.dart';
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
          CherryToast.success(
            title: Text(
              (state.message?.trim().isNotEmpty ?? false)
                  ? state.message!
                  : context.tr(LocaleKeys.reportSent),
              style:
                  const TextStyle(color: AppColors.mainColor),
            ),
          ).show(context);
          Navigator.pop(context, true);
        } else if (state is ReportAdError) {
          final msg = state.message == 'selectReason'
              ? context.tr(LocaleKeys.pleaseSelectReason)
              : state.message;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        }
      },
      builder: (context, state) {
        final cubit = ReportProductCubit.get(context);

        if (state is GetReportReasonsLoading &&
            cubit.reportReasons.isEmpty) {
          return const CustomLoading();
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
                  style: TextStyle(color: Colors.grey.shade500),
                )
              else
                ...reasons.map((reason) {
                  final key = reason.id ?? '${reason.id}';
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
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? AppColors.mainColor
                                : const Color(0xFFE3E6E9),
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
                                      : const Color(0xff1F2937),
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
                                      : const Color(0xffD0D0D0),
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
              CustomButton(
                btnText: submitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        context.tr(LocaleKeys.send),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteColor,
                        ),
                      ),
                onPressed: submitting
                    ? () {}
                    : () {
                        if (cubit.selectedReasonKey == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(context.tr(
                                  LocaleKeys.pleaseSelectReason)),
                            ),
                          );
                          return;
                        }
                        cubit.submitReportAd(
                          sellerId: widget.sellerId,
                          productId: widget.productId,
                        );
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}
