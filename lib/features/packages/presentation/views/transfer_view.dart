import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared_widgets/custom_button.dart';
import '../../../../core/shared_widgets/custom_error_widget.dart';
import '../../../../core/shared_widgets/custom_loading.dart';
import '../../../../core/shared_widgets/custom_text_form_filed.dart';
import '../../../../core/utils/app_colors/app_colors.dart';
import '../../../../core/utils/new_toast/toast.dart';
import '../../../PaymentBalance/presentation/view_model/wallet_cubit.dart';
import '../../../PaymentBalance/presentation/view_model/wallet_states.dart';
import '../../data/models/packages_model.dart';
import '../../data/models/payment_methods_model.dart';
import '../view_model/packages_cubit.dart';
import '../view_model/packages_states.dart';
import 'packages_widgets/brand_logo.dart';

/// Brand identity per payment method (matched by code/name).
class _Brand {
  const _Brand(this.color, this.icon,
      [this.kind = BrandLogoKind.generic]);
  final Color color;
  final IconData icon;
  final BrandLogoKind kind;
}

_Brand _brandFor(PaymentMethod method) {
  final text =
      '${method.code ?? ''} ${method.name ?? ''}'.toLowerCase();
  if (text.contains('vodafone') || text.contains('فودافون')) {
    return const _Brand(
      Color(0xffE60000),
      Icons.smartphone_rounded,
      BrandLogoKind.vodafone,
    );
  }
  if (text.contains('orange') ||
      text.contains('اورنج') ||
      text.contains('أورانج')) {
    return const _Brand(Color(0xffFF7900), Icons.smartphone_rounded);
  }
  if (text.contains('etisalat') ||
      text.contains('اتصالات') ||
      text.contains('e&') ||
      text.contains('إي_اند')) {
    return const _Brand(
      Colors.black,
      Icons.smartphone_rounded,
      BrandLogoKind.etisalat,
    );
  }
  if (text.contains('instapay') ||
      text.contains('انستا') ||
      text.contains('insta_pay')) {
    return const _Brand(
      Color(0xff5B2C86),
      Icons.bolt_rounded,
      BrandLogoKind.instapay,
    );
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

/// One payment-methods page for both flows (same page, same look):
/// - Subscription mode ([package] set): transfer checkout for a package.
///   On success it pops back and the packages page refreshes.
/// - Wallet top-up mode ([topUpMode] true): amount + method + receipt,
///   posted to wallet/top-up. On success it pops back and the history
///   refreshes.
class TransferView extends StatefulWidget {
  const TransferView({super.key, this.package, this.topUpMode = false})
      : assert(
            (package == null) == topUpMode,
            'Pass either package or topUpMode');

  final Packages? package;
  final bool topUpMode;

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = PackagesCubit.get(context);
    cubit.clearTransferForm();
    cubit.getPaymentMethods();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = PackagesCubit.get(context);
    final topUpMode = widget.topUpMode;
    final scaffold = Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor: AppColors.mainColor,
        title: Text(
          topUpMode ? "شحن رصيد المحفظة" : "إتمام الاشتراك",
          style: const TextStyle(
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
          final package = widget.package;
          final paying = !topUpMode &&
              cubit.subscribingPackageId != null &&
              cubit.subscribingPackageId == package?.id;
          final canConfirm = cubit.selectedMethod?.code != null &&
              cubit.receiptImage != null &&
              !paying &&
              (topUpMode || package?.id != null);
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Package summary / wallet amount.
                if (topUpMode)
                  CustomTextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    hintText: "المبلغ",
                  )
                else
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
                            package?.name ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1F2937),
                            ),
                          ),
                        ),
                        Text(
                          package?.durationLabel ?? '',
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
                                    color: Colors.white,
                                    border: Border.all(
                                      color: selected
                                          ? brand.color
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
                                      // Official company logo.
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          BrandLogo(
                                            kind: brand.kind,
                                            fallbackIcon: brand.icon,
                                            fallbackColor: brand.color,
                                          ),
                                          if (selected)
                                            Positioned(
                                              bottom: -4,
                                              right: -4,
                                              child: Container(
                                                decoration:
                                                    const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.check_circle_rounded,
                                                  size: 20,
                                                  color: brand.color,
                                                ),
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
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color: brand.color,
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
                                                  style: TextStyle(
                                                    fontSize: 12.5,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: brand.color,
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
                                          icon: Icon(
                                            Icons.copy_rounded,
                                            size: 18,
                                            color: brand.color,
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
                if (topUpMode)
                  BlocBuilder<WalletCubit, WalletStates>(
                    builder: (context, walletState) {
                      final walletPaying =
                          walletState is TopUpLoadingState;
                      return _ConfirmButton(
                        loading: walletPaying,
                        label: "تأكيد الشحن",
                        onPressed: walletPaying
                            ? null
                            : () {
                                final amount = _amountController
                                    .text
                                    .trim();
                                if (amount.isEmpty ||
                                    double.tryParse(amount) ==
                                        null) {
                                  Toast.showErrorToast(
                                    msg: "من فضلك أدخل المبلغ",
                                    context: context,
                                  );
                                  return;
                                }
                                final method =
                                    cubit.selectedMethod;
                                final receipt =
                                    cubit.receiptImage;
                                if (method?.code == null ||
                                    receipt == null) {
                                  return;
                                }
                                context
                                    .read<WalletCubit>()
                                    .topUp(
                                      amount: amount,
                                      paymentMethod:
                                          method!.code!,
                                      receiptPath: receipt.path,
                                    );
                              },
                      );
                    },
                  )
                else
                  _ConfirmButton(
                    loading: paying,
                    label: "تأكيد الاشتراك",
                    onPressed: !canConfirm || package?.id == null
                        ? null
                        : () => cubit.checkoutWithTransfer(
                              packageId: package!.id!,
                            ),
                  ),
              ],
            ),
          );
        },
      ),
    );
    // Wallet mode: top-up result pops back + refreshes the history.
    if (topUpMode) {
      return BlocListener<WalletCubit, WalletStates>(
        listener: (context, state) {
          if (state is TopUpSuccessState) {
            Toast.showSuccessToast(
              msg: state.message.isNotEmpty
                  ? state.message
                  : "تم إرسال طلب الشحن بنجاح",
              context: context,
            );
            context.read<WalletCubit>().getHistory();
            Navigator.pop(context);
          } else if (state is TopUpErrorState) {
            Toast.showErrorToast(
                msg: state.error, context: context);
          }
        },
        child: scaffold,
      );
    }
    return scaffold;
  }
}

/// Shared confirm button with loading state.
class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({
    required this.loading,
    required this.label,
    required this.onPressed,
  });

  final bool loading;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      btnText: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
      onPressed: onPressed ?? () {},
    );
  }
}
