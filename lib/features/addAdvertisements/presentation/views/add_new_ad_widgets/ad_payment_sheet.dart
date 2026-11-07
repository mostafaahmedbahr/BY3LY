import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_services/remote_services/service_locator.dart';
import '../../../../../core/shared_widgets/custom_button.dart';
import '../../../../../core/shared_widgets/custom_loading.dart';
import '../../../../../core/shared_widgets/custom_text_form_filed.dart';
import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../../../../core/utils/new_toast/toast.dart';
import '../../../data/models/ad_publishing_settings_model.dart';
import '../../../../packages/data/repos/packages_repos_imple.dart';
import '../../../../packages/presentation/view_model/packages_cubit.dart';
import '../../../../packages/presentation/view_model/packages_states.dart';
import '../../../../packages/presentation/views/packages_widgets/transfer_method_card.dart';
import '../../../../profile/presentation/view_model/profile_cubit.dart';
import '../../view_model/add_new_ad_cubit.dart';
import '../../view_model/add_new_ad_states.dart';

/// Payment step shown when publishing a new ad and the package / free
/// ads are exhausted — mirrors the website's create-ad payment section
/// (same shape as the wallet top-up flow): publishing fee from
/// ad-publishing-settings, wallet (when the balance covers it) or a
/// transfer method + transfer reference + receipt. The chosen keys are
/// posted to addNewAds (payment_method / receipt / transfer_reference).
Future<void> showAdPaymentSheet(BuildContext context) {
  final adCubit = AddNewAdCubit.get(context);
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
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

  bool _loadingSettings = true;
  bool _settingsFailed = false;
  AdPublishingSettingsModel? _settings;

  /// Optional transfer reference number (رقم مرجع التحويل).
  final TextEditingController _referenceCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fields already start in the loading state, so the initial fetch
    // needs no setState (it runs synchronously until the first await).
    _fetchSettings();
  }

  @override
  void dispose() {
    _referenceCon.dispose();
    super.dispose();
  }

  /// Retry button: show loading again, then refetch the fee.
  Future<void> _loadSettings() async {
    setState(() {
      _loadingSettings = true;
      _settingsFailed = false;
    });
    await _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    final result =
        await context.read<AddNewAdCubit>().loadPublishingSettings();
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _loadingSettings = false;
        _settingsFailed = true;
      }),
      (settings) {
        setState(() {
          _loadingSettings = false;
          _settings = settings;
        });
        // No fee configured → nothing to pay, publish right away.
        if ((settings.price ?? 0) <= 0) {
          context.read<AddNewAdCubit>().submit();
        }
      },
    );
  }

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
      transferReference: _referenceCon.text.trim().isEmpty
          ? null
          : _referenceCon.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adCubit = context.read<AddNewAdCubit>();
    final user =
        context.read<ProfileCubit>().profileModel?.data?.user;
    final balance = user?.walletBalance;
    final fee = _settings?.price ?? 0;
    final walletCoversFee = (balance ?? 0) >= fee;
    return BlocListener<AddNewAdCubit, AddNewAdStates>(
      listener: (context, state) {
        // Close only the sheet; the page listener shows the toast
        // and pops the page with result=true.
        if (state is AddNewAdSuccess) {
          Navigator.pop(context);
        } else if (state is AddNewAdPaymentRequired ||
            state is AddNewAdError) {
          // The sheet is the visible surface here — toast instead of
          // a snackbar hidden behind it.
          Toast.showErrorToast(
            msg: state is AddNewAdPaymentRequired
                ? state.message
                : (state as AddNewAdError).message,
            context: context,
          );
        }
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
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'اختر طريقة الدفع',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'الباقة أو الإعلانات المجانية خلصت — ادفع رسوم النشر لإعلانك',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                if (_loadingSettings)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CustomLoading(),
                  )
                else if (_settingsFailed)
                  _SettingsError(onRetry: _loadSettings)
                else ...[
                  // Publishing fee + wallet balance (same info the
                  // website shows above its payment section).
                  _FeeCard(
                    feeLabel: _settings?.priceLabel ?? '0 ج.م',
                    balanceLabel:
                        '${_formatBalance(balance)} ${_settings?.currencyLabel ?? 'ج.م'}',
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<AddNewAdCubit, AddNewAdStates>(
                    builder: (context, adState) {
                      final submitting = adState is AddNewAdLoading;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Wallet: only when the balance covers the fee.
                          _OptionTile(
                            icon:
                                Icons.account_balance_wallet_outlined,
                            title: 'محفظة بيعلي',
                            subtitle: walletCoversFee
                                ? 'سيتم خصم ${_settings?.priceLabel ?? ''} من رصيد محفظتك.'
                                : 'رصيد محفظتك غير كافٍ. اشحن المحفظة أو ادفع بالتحويل.',
                            enabled: walletCoversFee,
                            trailing: submitting && !_showTransfer
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: AppColors.mainColor,
                                    ),
                                  )
                                : Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                            onTap: submitting
                                ? null
                                : () {
                                    if (!walletCoversFee) {
                                      Toast.showErrorToast(
                                        msg:
                                            'رصيد محفظتك غير كافٍ. اشحن المحفظة أو ادفع بالتحويل.',
                                        context: context,
                                      );
                                      return;
                                    }
                                    _submitWallet(adCubit);
                                  },
                          ),
                          const SizedBox(height: 12),
                          // Transfer: expands the reference + receipt
                          // form inline (same as the wallet top-up).
                          _OptionTile(
                            icon: Icons.swap_horiz_rounded,
                            title: 'تحويل',
                            subtitle:
                                'تحويل بنكي أو محافظ إلكترونية',
                            trailing: Icon(
                              _showTransfer
                                  ? Icons
                                      .keyboard_arrow_down_rounded
                                  : Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: AppColors.mainColor,
                            ),
                            onTap: submitting
                                ? null
                                : () => setState(
                                    () =>
                                        _showTransfer = !_showTransfer),
                          ),
                          if (_showTransfer) ...[
                            const SizedBox(height: 12),
                            _TransferForm(
                              submitting: submitting,
                              referenceController: _referenceCon,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fee + balance summary card.
class _FeeCard extends StatelessWidget {
  const _FeeCard({required this.feeLabel, required this.balanceLabel});

  final String feeLabel;
  final String balanceLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.mainColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'رسوم النشر',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                feeLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'رصيد المحفظة',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                balanceLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ad-publishing-settings failed to load → cannot show the fee.
class _SettingsError extends StatelessWidget {
  const _SettingsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 38,
            color: AppColors.redColor,
          ),
          const SizedBox(height: 8),
          Text(
            'تعذر تحميل إعدادات النشر. حاول مرة أخرى.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          CustomButton(
            btnText: const Text(
              'إعادة المحاولة',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

/// Transfer methods + transfer reference + receipt picker + confirm,
/// all inside the sheet.
class _TransferForm extends StatelessWidget {
  const _TransferForm({
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
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  /// false = balance doesn't cover the fee → dimmed, but tapping
  /// still explains why it can't be used.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color:
                      AppColors.mainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
