import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:by3ly/features/addAdvertisements/data/models/ad_publishing_settings_model.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_cubit.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_states.dart';
import 'package:by3ly/features/packages/data/repos/packages_repos_imple.dart';
import 'package:by3ly/features/packages/presentation/view_model/packages_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'payment_fee_card.dart';
import 'payment_option_tile.dart';
import 'payment_settings_error.dart';
import 'transfer_form.dart';

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
      child: const AdPaymentSheetBody(),
    ),
  );
}

class AdPaymentSheetBody extends StatefulWidget {
  const AdPaymentSheetBody({super.key});

  @override
  State<AdPaymentSheetBody> createState() => _AdPaymentSheetBodyState();
}

class _AdPaymentSheetBodyState extends State<AdPaymentSheetBody> {
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
                // Grabber
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 14),
                // Premium header: gradient icon badge + title + hint
                Row(
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.mainColor,
                            AppColors.secondColor,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mainColor
                                .withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.payments_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اختر طريقة الدفع',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'الباقة أو الإعلانات المجانية خلصت — ادفع رسوم النشر لإعلانك',
                            style: TextStyle(
                              fontSize: 11.5,
                              height: 1.45,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_loadingSettings)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CustomLoading(),
                  )
                else if (_settingsFailed)
                  PaymentSettingsError(onRetry: _loadSettings)
                else ...[
                  // Publishing fee + wallet balance (same info the
                  // website shows above its payment section).
                  PaymentFeeCard(
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
                          PaymentOptionTile(
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
                          PaymentOptionTile(
                            icon: Icons.swap_horiz_rounded,
                            title: 'تحويل',
                            expanded: _showTransfer,
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
                            TransferForm(
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
