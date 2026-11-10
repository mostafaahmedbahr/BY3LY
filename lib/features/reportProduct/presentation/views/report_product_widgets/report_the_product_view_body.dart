import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:by3ly/features/reportProduct/presentation/view_model/report_product_cubit.dart';
import 'package:by3ly/features/reportProduct/presentation/view_model/report_product_states.dart';
import 'package:by3ly/features/reportProduct/presentation/views/report_product_widgets/reason_item_widget.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// General complaint flow (e.g. from Help & Support): pick a reason,
/// describe the issue, then POST the complaint.
class ReportTheProductViewBody extends StatelessWidget {
  const ReportTheProductViewBody({super.key, this.sellerId, this.productId});

  final int? sellerId;
  final int? productId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportProductCubit, ReportProductStates>(
      listener: (context, state) {
        if (state is AddComplaintSuccess) {
          final msg = state.addComplaintModel.message?.trim();
          Toast.showSuccessToast(
            msg: (msg != null && msg.isNotEmpty)
                ? msg
                : context.tr(LocaleKeys.reportSent),
            context: context,
          );
          ReportProductCubit.get(context).resetValues();
        } else if (state is AddComplaintError) {
          Toast.showErrorToast(msg: state.message, context: context);
        }
      },
      builder: (context, state) {
        final cubit = ReportProductCubit.get(context);
        final reasons = cubit.allComplaintsTypesList;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text(
                context.tr(LocaleKeys.reasonForReport),
                style: AppStyles.textStyle16W600Black.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                context.tr(LocaleKeys.tellUsWhatHappened),
                style: AppStyles.textStyle12W600Gary,
              ),
              const SizedBox(height: 16),

              // ---- Reasons ----
              if (state is GetComplaintsTypesLoading)
                Column(
                  children: List.generate(
                    4,
                    (_) => const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: SimmerLoading(height: 50, raduis: 14),
                    ),
                  ),
                )
              else if (state is GetComplaintsTypesError && reasons.isEmpty)
                CustomErrorWidget(
                  error: state.message,
                  onTap: () => cubit.getAllComplaintsTypesData(),
                )
              else if (reasons.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Icon(
                      Icons.flag_outlined,
                      size: 48,
                      color: AppColors.border,
                    ),
                  ),
                )
              else
                ...reasons.map(
                  (reason) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ReasonItemWidget(
                      title: reason.text ?? '',
                      index: reason.id ?? 0,
                    ),
                  ),
                ),

              const SizedBox(height: 8),
              Text(
                context.tr(LocaleKeys.notes),
                style: AppStyles.textStyle16W600Black,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                keyboardType: TextInputType.text,
                hintText: context.tr(LocaleKeys.writeReasonForReport),
                maxLines: 5,
                controller: cubit.messageCon,
              ),
              const SizedBox(height: 28),

              // ---- Gold send CTA ----
              Builder(
                builder: (context) {
                  final submitting = state is AddComplaintLoading;
                  return SizedBox(
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
                        boxShadow: submitting
                            ? null
                            : [
                                BoxShadow(
                                  color: AppColors.yellowColor
                                      .withValues(alpha: 0.40),
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
                                  final reason = cubit.reasonIndex;
                                  if (reason == null) {
                                    Toast.showErrorToast(
                                      msg: context.tr(
                                        LocaleKeys.pleaseSelectReason,
                                      ),
                                      context: context,
                                    );
                                    return;
                                  }
                                  cubit.addComplaint(
                                    productId: productId,
                                    sellerId: sellerId,
                                    message: cubit.messageCon.text,
                                    complaintId: reason,
                                  );
                                },
                          child: Center(
                            child: submitting
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
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
