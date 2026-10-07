import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared_widgets/custom_button.dart';
import '../../../../core/shared_widgets/custom_error_widget.dart';
import '../../../../core/shared_widgets/custom_loading.dart';
import '../../../../core/utils/app_colors/app_colors.dart';
import '../../../../core/utils/new_toast/toast.dart';
import '../../data/models/packages_model.dart';
import '../../data/models/payment_methods_model.dart';
import '../view_model/packages_cubit.dart';
import '../view_model/packages_states.dart';

/// Brand identity per payment method (matched by code/name).
class _Brand {
  const _Brand(this.color, this.icon);
  final Color color;
  final IconData icon;
}

_Brand _brandFor(PaymentMethod method) {
  final text =
      '${method.code ?? ''} ${method.name ?? ''}'.toLowerCase();
  if (text.contains('vodafone') || text.contains('فودافون')) {
    return const _Brand(Color(0xffE60000), Icons.smartphone_rounded);
  }
  if (text.contains('orange') ||
      text.contains('اورنج') ||
      text.contains('أورانج')) {
    return const _Brand(Color(0xffFF7900), Icons.smartphone_rounded);
  }
  if (text.contains('etisalat') ||
      text.contains('اتصالات') ||
      text.contains('e&')) {
    return const _Brand(Color(0xff008A45), Icons.smartphone_rounded);
  }
  if (text.contains('instapay') || text.contains('انستا')) {
    return const _Brand(Color(0xff00A9CE), Icons.bolt_rounded);
  }
  if (text.contains('fawry') || text.contains('فوري')) {
    return const _Brand(Color(0xffB8860B), Icons.storefront_rounded);
  }
  if (text.contains('bank') ||
      text.contains('بنك') ||
      text.contains('iban') ||
      text.contains('حساب بنكي')) {
    return const _Brand(
        Color(0xff1B3A6B), Icons.account_balance_rounded);
  }
  if (text.contains('wallet') || text.contains('محفظ')) {
    return const _Brand(
        AppColors.mainColor, Icons.account_balance_wallet_rounded);
  }
  if (text.contains('cash') || text.contains('كاش')) {
    return const _Brand(Color(0xff2E7D32), Icons.payments_rounded);
  }
  return const _Brand(AppColors.mainColor, Icons.swap_horiz_rounded);
}

/// Transfer checkout page: pick a transfer method, upload the receipt,
/// then confirm. On success it pops back and the packages page refreshes.
class TransferView extends StatefulWidget {
  const TransferView({super.key, required this.package});

  final Packages package;

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  @override
  void initState() {
    super.initState();
    final cubit = PackagesCubit.get(context);
    cubit.clearTransferForm();
    cubit.getPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = PackagesCubit.get(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor: AppColors.mainColor,
        title: const Text(
          "إتمام الاشتراك",
          style: TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<PackagesCubit, PackagesStates>(
        listener: (context, state) {
          if (state is SubscribePackageSuccessState) {
            // The packages page shows the toast and refreshes.
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final paying =
              cubit.subscribingPackageId == widget.package.id;
          final canConfirm = cubit.selectedMethod?.code != null &&
              cubit.receiptImage != null &&
              !paying;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Package summary.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:
                        AppColors.mainColor.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.package.name ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1F2937),
                          ),
                        ),
                      ),
                      Text(
                        widget.package.durationLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "اختر طريقة التحويل",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1F2937),
                  ),
                ),
                const SizedBox(height: 10),
                if (state is GetPaymentMethodsLoadingState)
                  const Expanded(child: CustomLoading())
                else if (state is GetPaymentMethodsErrorState)
                  Expanded(
                    child: CustomErrorWidget(
                      error: state.error,
                      onTap: () =>
                          cubit.getPaymentMethods(forceRefresh: true),
                    ),
                  )
                else
                  Expanded(
                    child: cubit.paymentMethods.isEmpty
                        ? const Center(
                            child: Text(
                              "لا يوجد طرق تحويل متاحة",
                              style: TextStyle(
                                  color: Color(0xff9AA0A6)),
                            ),
                          )
                        : ListView.separated(
                            itemCount: cubit.paymentMethods.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final method =
                                  cubit.paymentMethods[index];
                              final selected =
                                  cubit.selectedMethod == method;
                              final brand = _brandFor(method);
                              return InkWell(
                                onTap: () =>
                                    cubit.selectMethod(method),
                                borderRadius:
                                    BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                    color: selected
                                        ? AppColors.mainColor
                                            .withValues(alpha: 0.05)
                                        : Colors.white,
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.mainColor
                                          : const Color(0xffE3E6E9),
                                      width: selected ? 1.5 : 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                            alpha: 0.03),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Company mark: brand-colored badge.
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            height: 52,
                                            width: 52,
                                            decoration: BoxDecoration(
                                              color: brand.color
                                                  .withValues(
                                                      alpha: 0.12),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      15),
                                            ),
                                            child: Icon(
                                              brand.icon,
                                              size: 26,
                                              color: brand.color,
                                            ),
                                          ),
                                          if (selected)
                                            const Positioned(
                                              bottom: -4,
                                              right: -4,
                                              child: Icon(
                                                Icons.check_circle_rounded,
                                                size: 20,
                                                color:
                                                    AppColors.mainColor,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              method.name ?? '',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color: Color(0xff1F2937),
                                              ),
                                            ),
                                            if ((method.account?.trim()
                                                    .isNotEmpty ??
                                                false)) ...[
                                              const SizedBox(height: 4),
                                              Container(
                                                padding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                      0xffF1F3F5),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(8),
                                                ),
                                                child: Text(
                                                  method.account!,
                                                  style:
                                                      const TextStyle(
                                                    fontSize: 12.5,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: Color(
                                                        0xff1F2937),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if ((method.account?.trim()
                                              .isNotEmpty ??
                                          false))
                                        IconButton(
                                          tooltip: "نسخ",
                                          onPressed: () {
                                            Clipboard.setData(
                                              ClipboardData(
                                                  text:
                                                      method.account!),
                                            );
                                            Toast.showSuccessToast(
                                              msg: "تم نسخ الرقم",
                                              context: context,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.copy_rounded,
                                            size: 18,
                                            color: AppColors.mainColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                const SizedBox(height: 12),
                // Receipt picker.
                InkWell(
                  onTap: paying ? null : () => cubit.pickReceipt(),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xffE3E6E9)),
                    ),
                    child: cubit.receiptImage == null
                        ? const Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 34,
                                color: AppColors.mainColor,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "ارفع صورة التحويل",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff9AA0A6),
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(13),
                                child: Image.file(
                                  File(cubit.receiptImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black
                                        .withValues(alpha: 0.6),
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    "تغيير الصورة",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  btnText: paying
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "تأكيد الاشتراك",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                  onPressed: () {
                    if (!canConfirm ||
                        widget.package.id == null) {
                      return;
                    }
                    cubit.checkoutWithTransfer(
                      packageId: widget.package.id!,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
