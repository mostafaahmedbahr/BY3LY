import 'dart:io';

import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/packages/presentation/view_model/packages_cubit.dart';
import 'package:by3ly/features/packages/presentation/view_model/packages_states.dart';
import 'package:by3ly/features/packages/presentation/views/packages_widgets/transfer_method_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'change_photo_label.dart';

/// Transfer methods list + transfer reference + receipt picker + confirm
/// button — rendered inline inside the ad payment sheet.
class TransferForm extends StatelessWidget {
  const TransferForm({
    super.key,
    required this.submitting,
    required this.referenceController,
    required this.onConfirm,
  });

  final bool submitting;
  final TextEditingController referenceController;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackagesCubit, PackagesStates>(
      builder: (context, state) {
        final payCubit = context.read<PackagesCubit>();
        if (state is GetPaymentMethodsLoadingState &&
            payCubit.paymentMethods.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: CustomLoading(),
          );
        }
        if (payCubit.paymentMethods.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'لا يوجد طرق تحويل متاحة',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اختر طريقة التحويل',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            // Same method cards as the packages transfer page.
            ...payCubit.paymentMethods.map((method) {
              final selected = payCubit.selectedMethod == method;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TransferMethodCard(
                  method: method,
                  selected: selected,
                  enabled: !submitting,
                  onTap: () => payCubit.selectMethod(method),
                ),
              );
            }),
            const SizedBox(height: 4),
            Text(
              'رقم مرجع التحويل (اختياري)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),
            CustomTextFormField(
              controller: referenceController,
              keyboardType: TextInputType.number,
              hintText: 'رقم مرجع التحويل',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.tag_rounded,
                  color: AppColors.mainColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: submitting ? null : () => payCubit.pickReceipt(),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: payCubit.receiptImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cloud_upload_outlined,
                            size: 34,
                            color: AppColors.mainColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ارفع صورة التحويل',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.file(
                              File(payCubit.receiptImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Positioned(
                            top: 8,
                            left: 8,
                            child: ChangePhotoLabel(),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
            // Select a method + attach receipt, then publish the ad.
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
                  : const Text(
                      'نشر الإعلان',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
              onPressed: onConfirm,
            ),
          ],
        );
      },
    );
  }
}
