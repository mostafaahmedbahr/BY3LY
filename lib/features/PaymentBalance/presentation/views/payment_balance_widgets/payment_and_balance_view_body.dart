import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/features/PaymentBalance/data/models/wallet_history_model.dart';
import 'package:by3ly/features/PaymentBalance/presentation/view_model/wallet_cubit.dart';
import 'package:by3ly/features/PaymentBalance/presentation/view_model/wallet_states.dart';
import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/features/packages/data/models/packages_model.dart';
import 'package:by3ly/features/packages/data/repos/packages_repos_imple.dart';
import 'package:by3ly/features/packages/presentation/view_model/packages_cubit.dart';
import 'package:by3ly/features/packages/presentation/view_model/packages_states.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../lang/locale_keys.dart';
import '../../../../packages/presentation/views/transfer_view.dart';

class PaymentAndBalanceViewBody extends StatefulWidget {
  const PaymentAndBalanceViewBody({super.key});

  @override
  State<PaymentAndBalanceViewBody> createState() =>
      _PaymentAndBalanceViewBodyState();
}

class _PaymentAndBalanceViewBodyState extends State<PaymentAndBalanceViewBody> {
  @override
  void initState() {
    super.initState();
    // The history is loaded by the WalletCubit provider. Refresh the
    // balance too on every entry so an approved top-up shows up.
    // Deferred to after the first frame so emitting a state does not
    // rebuild listeners while the tree is still building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProfileCubit>().getProfile();
    });
  }

  /// Refreshes both the balance card (profile) and the history list.
  Future<void> _refresh() async {
    await Future.wait([
      context.read<ProfileCubit>().getProfile(),
      context.read<WalletCubit>().getHistory(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            color: AppColors.mainColor,
            onRefresh: _refresh,
            child: BlocBuilder<WalletCubit, WalletStates>(
              builder: (context, state) {
                final cubit = WalletCubit.get(context);
                final loading =
                    state is GetWalletHistoryLoadingState ||
                    state is WalletInitState;
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  children: [
                    if (loading)
                      const _WalletPageShimmer()
                    else ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.mainColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.tr(LocaleKeys.balance),
                                  style: AppStyles.textStyle14W500White,
                                ),
                                IconButton(
                                  onPressed: _refresh,
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: AppColors.yellowColor,
                                  ),
                                ),
                              ],
                            ),
                            BlocBuilder<ProfileCubit, ProfileStates>(
                              builder: (context, state) {
                                final balance = context
                                    .read<ProfileCubit>()
                                    .profileModel
                                    ?.data
                                    ?.user
                                    ?.walletBalance;
                                if (balance == null) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: SimmerLoading(
                                      height: 24,
                                      width: 100,
                                      raduis: 8,
                                    ),
                                  );
                                }
                                final text =
                                    '${balance == balance.roundToDouble() ? balance.toInt() : balance} ج.م';
                                return Text(
                                  text,
                                  style: AppStyles.textStyle14W500White
                                      .copyWith(fontSize: 24),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<PackagesCubit, PackagesStates>(
                        builder: (context, state) {
                          final packages = PackagesCubit.get(
                            context,
                          ).allPackages;
                          Packages? current;
                          for (final p in packages) {
                            if (p.isSubscriped == true) {
                              current = p;
                              break;
                            }
                          }
                          if (current == null) {
                            return const SizedBox.shrink();
                          }
                          final pkg = current;
                          var endsAt = (pkg.endsAt ?? '').trim();
                          if (endsAt.length > 10) {
                            endsAt = endsAt.substring(0, 10);
                          }
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.mainColor.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.card_membership_rounded,
                                      size: 18,
                                      color: AppColors.mainColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'الباقة الحالية: ${pkg.name ?? ''}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.text,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'ينتهي في: ${endsAt.isNotEmpty ? endsAt : '...'}',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      pkg.remainingAds != null
                                          ? 'المتبقي: ${pkg.remainingAds} إعلان'
                                          : '',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.mainColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          context.tr(LocaleKeys.previousActivities),
                          style: AppStyles.textStyle16W500Black,
                        ),
                      ),
                      if (state is GetWalletHistoryErrorState)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: CustomErrorWidget(
                            error: state.error,
                            onTap: () => cubit.getHistory(),
                          ),
                        )
                      else if (cubit.history.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Text(
                              "لا يوجد عمليات سابقة",
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        )
                      else
                        Column(
                          children: [
                            for (int i = 0; i < cubit.history.length; i++) ...[
                              if (i > 0) const CustomSizedBox(height: 16),
                              _HistoryItem(item: cubit.history[i]),
                            ],
                          ],
                        ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: CustomButton(
            btnText: Text(
              context.tr(LocaleKeys.addCredit),
              style: AppStyles.textStyle16W600Black.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
            onPressed: () async {
              // Pushed routes can't see this page's local providers,
              // so both cubits are passed explicitly with the new route.
              final added = await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: WalletCubit.get(context)),
                      BlocProvider(
                        create: (_) =>
                            PackagesCubit(getIt.get<PackagesRepoImpl>()),
                      ),
                    ],
                    child: const TransferView(topUpMode: true),
                  ),
                ),
              );
              // Top-up submitted → refresh the balance card and the
              // previous activities so the new operation shows up.
              if (added == true && mounted) {
                _refresh();
              }
            },
          ),
        ),
      ],
    );
  }
}

String _methodName(BuildContext context, String? code) {
  switch ((code ?? '').trim().toLowerCase()) {
    case 'vodafone_cash':
      return context.tr(LocaleKeys.payVodafoneCash);
    case 'etisalat_cash':
      return context.tr(LocaleKeys.payEtisalatCash);
    case 'orange_cash':
    case 'orange_money':
      return context.tr(LocaleKeys.payOrangeCash);
    case 'instapay':
      return context.tr(LocaleKeys.payInstapay);
    case 'bank':
    case 'bank_transfer':
      return context.tr(LocaleKeys.payBankTransfer);
    case 'wallet':
      return context.tr(LocaleKeys.payWallet);
    case 'fawry':
      return context.tr(LocaleKeys.payFawry);
    default:
      return (code ?? '').trim();
  }
}

void _showReceipt(BuildContext context, String url) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _ReceiptSheet(url: url),
  );
}

/// Modern receipt viewer with download + share.
class _ReceiptSheet extends StatefulWidget {
  const _ReceiptSheet({required this.url});

  final String url;

  @override
  State<_ReceiptSheet> createState() => _ReceiptSheetState();
}

class _ReceiptSheetState extends State<_ReceiptSheet> {
  bool _downloading = false;
  bool _sharing = false;

  Future<String?> _downloadTemp() async {
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await Dio().download(widget.url, path);
    return path;
  }

  /// Save straight to the phone gallery.
  Future<void> _download() async {
    if (_downloading || _sharing) return;
    setState(() => _downloading = true);
    try {
      final path = await _downloadTemp();
      if (!mounted || path == null) return;
      await Gal.putImage(path);
      if (!mounted) return;
      Toast.showSuccessToast(msg: "تم حفظ الصورة في المعرض", context: context);
    } catch (_) {
      if (!mounted) return;
      Toast.showErrorToast(msg: "تعذر حفظ الصورة", context: context);
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  Future<void> _share() async {
    if (_downloading || _sharing) return;
    setState(() => _sharing = true);
    try {
      final path = await _downloadTemp();
      if (!mounted || path == null) return;
      await SharePlus.instance.share(
        ShareParams(files: [XFile(path)], text: 'إيصال التحويل'),
      );
    } catch (_) {
      if (!mounted) return;
      Toast.showErrorToast(msg: "تعذر مشاركة الصورة", context: context);
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.62;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
            const SizedBox(height: 12),
            Text(
              'إيصال التحويل',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxH),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomNetWorkImage(
                  imageUrl: widget.url,
                  raduis: 16,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SheetAction(
                    icon: Icons.download_rounded,
                    label: 'تحميل',
                    busy: _downloading,
                    filled: true,
                    onTap: _download,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SheetAction(
                    icon: Icons.share_rounded,
                    label: 'مشاركة',
                    busy: _sharing,
                    filled: false,
                    onTap: _share,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.label,
    required this.busy,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool busy;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: busy ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: filled ? AppColors.mainColor : AppColors.surface,
          border: Border.all(
            color: filled ? AppColors.mainColor : AppColors.border,
          ),
        ),
        child: busy
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: filled ? Colors.white : AppColors.mainColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: filled ? Colors.white : AppColors.mainColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: filled ? Colors.white : AppColors.mainColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Full-page shimmer: balance card + package card + section header + rows.
class _WalletPageShimmer extends StatelessWidget {
  const _WalletPageShimmer();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Balance card.
        SimmerLoading(height: 118, raduis: 10),
        SizedBox(height: 12),
        // Current package card.
        SimmerLoading(height: 74, raduis: 10),
        SizedBox(height: 16),
        // "Previous activities" header.
        SimmerLoading(height: 16, width: 140, raduis: 6),
        SizedBox(height: 12),
        _WalletHistoryShimmer(),
      ],
    );
  }
}

/// Shimmer skeleton mirroring [_HistoryItem]: icon block + text lines.
class _WalletHistoryShimmer extends StatelessWidget {
  const _WalletHistoryShimmer();

  static const int _itemCount = 4;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < _itemCount; i++) ...[
          if (i > 0) const CustomSizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                SimmerLoading(height: 46, width: 46, raduis: 14),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: SimmerLoading(height: 12, raduis: 6)),
                          SizedBox(width: 12),
                          SimmerLoading(height: 12, width: 56, raduis: 6),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SimmerLoading(height: 10, width: 70, raduis: 5),
                          Spacer(),
                          SimmerLoading(height: 10, width: 50, raduis: 5),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({required this.item});

  final WalletHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final credit = item.isCredit;
    final amount = item.amount;
    final amountText = amount == null
        ? '...'
        : '${amount == amount.roundToDouble() ? amount.toInt() : amount} ج.م';
    final accent = credit ? AppColors.mainColor : AppColors.redColor;
    final methodName = _methodName(context, item.paymentMethod);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accent, accent.withValues(alpha: 0.6)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              credit
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        (item.typeLabel?.trim().isNotEmpty ?? false)
                            ? item.typeLabel!
                            : (credit ? 'إيداع' : 'خصم'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    Text(
                      '${credit ? '+' : '-'} $amountText',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (item.dateLabel.isNotEmpty) ...[
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.dateLabel,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const Spacer(),
                    _StatusPill(status: item.status, label: item.statusLabel),
                  ],
                ),
                if (methodName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    methodName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if ((item.receiptUrl?.trim().isNotEmpty ?? false)) ...[
                  const SizedBox(height: 8),
                  Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _showReceipt(context, item.receiptUrl!),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            size: 16,
                            color: AppColors.mainColor,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'عرض الإيصال',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small status pill colored by status value.
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.label});

  final String? status;
  final String? label;

  /// Normalized status group: approved / rejected / pending / unknown.
  String get _group {
    final v = '${status ?? ''} ${label ?? ''}'.toLowerCase();
    if (v.contains('approve') ||
        v.contains('success') ||
        v.contains('accept') ||
        v.contains('مقبول') ||
        v.contains('ناجح') ||
        v.contains('مكتمل')) {
      return 'approved';
    }
    if (v.contains('reject') ||
        v.contains('fail') ||
        v.contains('cancel') ||
        v.contains('مرفوض') ||
        v.contains('فاشل') ||
        v.contains('ملغي')) {
      return 'rejected';
    }
    if (v.contains('pend') ||
        v.contains('review') ||
        v.contains('wait') ||
        v.contains('قيد') ||
        v.contains('انتظار') ||
        v.contains('مراجعة')) {
      return 'pending';
    }
    return 'unknown';
  }

  Color get _color {
    switch (_group) {
      case 'approved':
        return const Color(0xff1B9E4B);
      case 'rejected':
        return AppColors.redColor;
      case 'pending':
        return const Color(0xffE8930C);
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    String text;
    switch (_group) {
      case 'approved':
        text = context.tr(LocaleKeys.statusApproved);
        break;
      case 'rejected':
        text = context.tr(LocaleKeys.statusRejected);
        break;
      case 'pending':
        text = context.tr(LocaleKeys.statusPending);
        break;
      default:
        text = (label?.trim().isNotEmpty ?? false)
            ? label!
            : (status ?? '').trim();
    }
    if (text.isEmpty) return const SizedBox.shrink();
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
