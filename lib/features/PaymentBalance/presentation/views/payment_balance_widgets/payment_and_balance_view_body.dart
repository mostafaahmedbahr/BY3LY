import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
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

class PaymentAndBalanceViewBody extends StatelessWidget {
  const PaymentAndBalanceViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    Text(context.tr(LocaleKeys.balance),style: AppStyles.textStyle14W500White,),
                    IconButton(onPressed: (){},
                        icon: const Icon(Icons.refresh,
                        color: AppColors.yellowColor,)
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
                    final text = balance == null
                        ? '...'
                        : '${balance == balance.roundToDouble() ? balance.toInt() : balance} ج.م';
                    return Text(
                      text,
                      style:
                          AppStyles.textStyle14W500White.copyWith(
                        fontSize: 24,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<PackagesCubit, PackagesStates>(
            builder: (context, state) {
              final packages =
                  PackagesCubit.get(context).allPackages;
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
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.mainColor
                          .withValues(alpha: 0.3)),
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
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1F2937),
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
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xff9AA0A6),
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
            child: Text(context.tr(LocaleKeys.previousActivities),style: AppStyles.textStyle16W500Black,),
          ),
          Expanded(
            child: BlocBuilder<WalletCubit, WalletStates>(
              builder: (context, state) {
                final cubit = WalletCubit.get(context);
                if (state is GetWalletHistoryLoadingState) {
                  return const CustomLoading();
                }
                if (state is GetWalletHistoryErrorState) {
                  return CustomErrorWidget(
                    error: state.error,
                    onTap: () => cubit.getHistory(),
                  );
                }
                final history = cubit.history;
                if (history.isEmpty) {
                  return const Center(
                    child: Text(
                      "لا يوجد عمليات سابقة",
                      style: TextStyle(color: Color(0xff9AA0A6)),
                    ),
                  );
                }
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return _HistoryItem(item: history[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const CustomSizedBox(height: 16);
                  },
                  itemCount: history.length,
                );
              },
            ),
          ),
          const CustomSizedBox(height: 20,),
          CustomButton(
            btnText: Text(context.tr(LocaleKeys.addCredit),
              style: AppStyles.textStyle16W600Black.copyWith(
                color: AppColors.whiteColor,
              ),),
            onPressed: (){
              // Pushed routes can't see this page's local providers,
              // so both cubits are passed explicitly with the new route.
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: WalletCubit.get(context),
                      ),
                      BlocProvider(
                        create: (_) => PackagesCubit(
                            getIt.get<PackagesRepoImpl>()),
                      ),
                    ],
                    child: const TransferView(topUpMode: true),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

String _methodName(String? code) {
  switch ((code ?? '').trim().toLowerCase()) {
    case 'vodafone_cash':
      return 'فودافون كاش';
    case 'etisalat_cash':
      return 'اتصالات كاش';
    case 'orange_cash':
    case 'orange_money':
      return 'أورانج كاش';
    case 'instapay':
      return 'انستاباي';
    case 'bank':
    case 'bank_transfer':
      return 'تحويل بنكي';
    case 'wallet':
      return 'محفظة';
    case 'fawry':
      return 'فوري';
    default:
      return (code ?? '').trim();
  }
}

void _showReceipt(BuildContext context, String url) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
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
      Toast.showSuccessToast(
        msg: "تم حفظ الصورة في المعرض",
        context: context,
      );
    } catch (_) {
      if (!mounted) return;
      Toast.showErrorToast(
        msg: "تعذر حفظ الصورة",
        context: context,
      );
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
        ShareParams(
          files: [XFile(path)],
          text: 'إيصال التحويل',
        ),
      );
    } catch (_) {
      if (!mounted) return;
      Toast.showErrorToast(
        msg: "تعذر مشاركة الصورة",
        context: context,
      );
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
                color: const Color(0xffE3E6E9),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'إيصال التحويل',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff1F2937),
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
          color: filled ? AppColors.mainColor : Colors.white,
          border: Border.all(
            color: filled
                ? AppColors.mainColor
                : const Color(0xffE3E6E9),
          ),
        ),
        child: busy
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: filled
                      ? Colors.white
                      : AppColors.mainColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: filled
                        ? Colors.white
                        : AppColors.mainColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: filled
                          ? Colors.white
                          : AppColors.mainColor,
                    ),
                  ),
                ],
              ),
      ),
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
    final accent =
        credit ? AppColors.mainColor : AppColors.redColor;
    final methodName = _methodName(item.paymentMethod);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
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
                colors: [
                  accent,
                  accent.withValues(alpha: 0.6),
                ],
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
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1F2937),
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
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 13,
                        color: Color(0xffB0B5BB),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.dateLabel,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xff9AA0A6),
                        ),
                      ),
                    ],
                    const Spacer(),
                    _StatusPill(
                        status: item.status,
                        label: item.statusLabel),
                  ],
                ),
                if (methodName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    methodName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff6B7280),
                    ),
                  ),
                ],
                if ((item.receiptUrl?.trim().isNotEmpty ?? false)) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () =>
                        _showReceipt(context, item.receiptUrl!),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor
                            .withValues(alpha: 0.08),
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

  Color get _color {
    final v = '${status ?? ''} ${label ?? ''}'.toLowerCase();
    if (v.contains('approve') ||
        v.contains('success') ||
        v.contains('accept') ||
        v.contains('مقبول') ||
        v.contains('ناجح') ||
        v.contains('مكتمل')) {
      return const Color(0xff1B9E4B);
    }
    if (v.contains('reject') ||
        v.contains('fail') ||
        v.contains('cancel') ||
        v.contains('مرفوض') ||
        v.contains('فاشل') ||
        v.contains('ملغي')) {
      return AppColors.redColor;
    }
    if (v.contains('pend') ||
        v.contains('review') ||
        v.contains('wait') ||
        v.contains('قيد') ||
        v.contains('انتظار') ||
        v.contains('مراجعة')) {
      return const Color(0xffE8930C);
    }
    return const Color(0xff9AA0A6);
  }

  @override
  Widget build(BuildContext context) {
    final text = (label?.trim().isNotEmpty ?? false)
        ? label!
        : ((status ?? '').trim().isNotEmpty ? status! : '');
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
