import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_services/remote_services/service_locator.dart';
import '../../../../../core/shared_widgets/custom_button.dart';
import '../../../../../core/shared_widgets/custom_loading.dart';
import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../../../../core/utils/new_toast/toast.dart';
import '../../../../packages/data/repos/packages_repos_imple.dart';
import '../../../../packages/presentation/view_model/packages_cubit.dart';
import '../../../../packages/presentation/view_model/packages_states.dart';
import '../../../../packages/presentation/views/packages_widgets/transfer_method_card.dart';
import '../../../../profile/presentation/view_model/profile_cubit.dart';
import '../../view_model/add_new_ad_cubit.dart';
import '../../view_model/add_new_ad_states.dart';

/// Bottom sheet shown when publishing a new ad:
/// wallet (pay directly) or transfer (pick method + receipt photo inline).
Future<void> showAdPaymentSheet(BuildContext context) {
  final adCubit = AddNewAdCubit.get(context);
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: adCubit),
        BlocProvider(
          create: (_) => PackagesCubit(getIt.get<PackagesRepoImpl>())
            ..getPaymentMethods(),
        ),
      ],
      child: const _AdPaymentSheetBody(),
    ),
  );
}

class _AdPaymentSheetBody extends StatefulWidget {
  const _AdPaymentSheetBody();

  @override
  State<_AdPaymentSheetBody> createState() => _AdPaymentSheetBodyState();
}

class _AdPaymentSheetBodyState extends State<_AdPaymentSheetBody> {
  /// false = choose step, true = transfer form expanded inline.
  bool _showTransfer = false;

  String _formatBalance(num? value) {
    if (value == null) return '...';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  void _submitWallet(AddNewAdCubit adCubit) {
    adCubit.submit(paymentMethod: 'wallet');
  }

  void _submitTransfer(
    AddNewAdCubit adCubit,
    PackagesCubit payCubit, {
    required bool submitting,
  }) {
    if (submitting) return;
    final method = payCubit.selectedMethod;
    final receipt = payCubit.receiptImage;
    if (method?.code == null) {
      Toast.showErrorToast(msg: 'اختر طريقة التحويل', context: context);
      return;
    }
    if (receipt == null) {
      Toast.showErrorToast(msg: 'ارفع صورة التحويل', context: context);
      return;
    }
    adCubit.submit(
      paymentMethod: method!.code!,
      receiptPath: receipt.path,
    );
  }

  @override
  Widget build(BuildContext context) {
    final adCubit = context.read<AddNewAdCubit>();
    final balance = context
        .read<ProfileCubit>()
        .profileModel
        ?.data
        ?.user
        ?.walletBalance;
    return BlocListener<AddNewAdCubit, AddNewAdStates>(
      listener: (context, state) {
        // Close only the sheet; the page listener shows the toast
        // and pops the page with result=true.
        if (state is AddNewAdSuccess) Navigator.pop(context);
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xffE3E6E9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'اختر طريقة الدفع',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ادفع من المحفظة أو حول وأرفق صورة التحويل',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff9AA0A6),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<AddNewAdCubit, AddNewAdStates>(
                  builder: (context, adState) {
                    final submitting = adState is AddNewAdLoading;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Wallet option: go ahead directly.
                        _OptionTile(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'محفظة',
                          subtitle:
                              'الرصيد المتاح: ${_formatBalance(balance)} ج.م',
                          trailing: submitting && !_showTransfer
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.mainColor,
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Color(0xffB0B5BB),
                                ),
                          onTap: submitting
                              ? null
                              : () => _submitWallet(adCubit),
                        ),
                        const SizedBox(height: 12),
                        // Transfer option: expands the receipt form inline.
                        _OptionTile(
                          icon: Icons.swap_horiz_rounded,
                          title: 'تحويل',
                          subtitle: 'تحويل بنكي أو محافظ إلكترونية',
                          trailing: Icon(
                            _showTransfer
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: AppColors.mainColor,
                          ),
                          onTap: submitting
                              ? null
                              : () => setState(
                                  () => _showTransfer = !_showTransfer),
                        ),
                        if (_showTransfer) ...[
                          const SizedBox(height: 12),
                          _TransferForm(
                            submitting: submitting,
                            onConfirm: () => _submitTransfer(
                              adCubit,
                              context.read<PackagesCubit>(),
                              submitting: submitting,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Transfer methods + receipt picker + confirm, all inside the sheet.
class _TransferForm extends StatelessWidget {
  const _TransferForm({
    required this.submitting,
    required this.onConfirm,
  });

  final bool submitting;
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
              border: Border.all(color: const Color(0xffE3E6E9)),
            ),
            child: const Text(
              'لا يوجد طرق تحويل متاحة',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xff9AA0A6)),
            ),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختر طريقة التحويل',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff1F2937),
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
            InkWell(
              onTap: submitting ? null : () => payCubit.pickReceipt(),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xffE3E6E9)),
                ),
                child: payCubit.receiptImage == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 34,
                            color: AppColors.mainColor,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'ارفع صورة التحويل',
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
                            borderRadius: BorderRadius.circular(13),
                            child: Image.file(
                              File(payCubit.receiptImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Positioned(
                            top: 8,
                            left: 8,
                            child: _ChangePhotoLabel(),
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

class _ChangePhotoLabel extends StatelessWidget {
  const _ChangePhotoLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'تغيير الصورة',
        style: TextStyle(fontSize: 11, color: Colors.white),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffE3E6E9)),
        ),
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.mainColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff9AA0A6),
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
