import 'dart:io';

import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:by3ly/features/PaymentBalance/presentation/view_model/wallet_cubit.dart';
import 'package:by3ly/features/PaymentBalance/presentation/view_model/wallet_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/packages_model.dart';
import '../view_model/packages_cubit.dart';
import '../view_model/packages_states.dart';
import 'packages_widgets/transfer_method_card.dart';

/// One payment-methods page for both flows (same page, same look):
/// - Subscription mode ([package] set): transfer checkout for a package.
///   On success it pops back and the packages page refreshes.
/// - Wallet top-up mode ([topUpMode] true): amount + method + receipt,
///   posted to wallet/top-up. On success it pops back with `true` and the
///   wallet page refreshes the balance and the history.
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

  /// Optional transfer reference number (رقم مرجع التحويل) — wallet
  /// top-up only, same key the website posts.
  final TextEditingController _referenceCon = TextEditingController();

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
    _referenceCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = PackagesCubit.get(context);
    final topUpMode = widget.topUpMode;
    final scaffold = Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.darkMainColor,
                AppColors.mainColor,
                AppColors.secondColor,
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),
        title: Row(
          children: [
            Icon(
              topUpMode
                  ? Icons.account_balance_wallet_rounded
                  : Icons.card_membership_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                topUpMode
                    ? context.tr(LocaleKeys.topUpWallet)
                    : context.tr(LocaleKeys.completeSubscription),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ],
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
                    hintText: context.tr(LocaleKeys.amountHint),
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
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
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
                Text(
                  context.tr(LocaleKeys.chooseTransferMethod),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
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
                        ? Center(
                            child: Text(
                              context.tr(LocaleKeys.noPaymentMethodsAvailable),
                              style: TextStyle(
                                  color: AppColors.textSecondary),
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
                              return TransferMethodCard(
                                method: method,
                                selected: selected,
                                onTap: () =>
                                    cubit.selectMethod(method),
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
                          color: AppColors.border),
                    ),
                    child: cubit.receiptImage == null
                        ? Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.cloud_upload_outlined,
                                size: 34,
                                color: AppColors.mainColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                context.tr(LocaleKeys.uploadTransferReceipt),
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
                                  child: Text(
                                    context.tr(LocaleKeys.changeImage),
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
                if (topUpMode) ...[
                  Text(
                    context.tr(LocaleKeys.transferReferenceOptional),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 6),
                  CustomTextFormField(
                    controller: _referenceCon,
                    keyboardType: TextInputType.number,
                    hintText: context.tr(LocaleKeys.transferReferenceHint),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.tag_rounded,
                        color: AppColors.mainColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (topUpMode)
                  BlocBuilder<WalletCubit, WalletStates>(
                    builder: (context, walletState) {
                      final walletPaying =
                          walletState is TopUpLoadingState;
                      return _ConfirmButton(
                        loading: walletPaying,
                        label: context.tr(LocaleKeys.confirmTopUp),
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
                                    msg: context.tr(LocaleKeys.enterValidAmount),
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
                                      transferReference:
                                          _referenceCon.text.trim().isEmpty
                                              ? null
                                              : _referenceCon.text
                                                  .trim(),
                                    );
                              },
                      );
                    },
                  )
                else
                  _ConfirmButton(
                    loading: paying,
                    label: context.tr(LocaleKeys.confirmSubscription),
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
    // Wallet mode: on success pop back with `true` so the wallet page
    // refreshes the balance and the history.
    if (topUpMode) {
      return BlocListener<WalletCubit, WalletStates>(
        listener: (context, state) {
          if (state is TopUpSuccessState) {
            Toast.showSuccessToast(
              msg: state.message.isNotEmpty
                  ? state.message
                  : context.tr(LocaleKeys.subscriptionSuccessful),
              context: context,
            );
            Navigator.pop(context, true);
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
