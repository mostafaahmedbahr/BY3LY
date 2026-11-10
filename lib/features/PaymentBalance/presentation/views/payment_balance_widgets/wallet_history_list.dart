import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/wallet_history_model.dart';
import 'receipt_sheet.dart';

/// Method-name lookup used by cards (shared across the screen).
String methodName(BuildContext context, String? code) {
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

class WalletHistoryList extends StatelessWidget {
  const WalletHistoryList({super.key, required this.items});

  final List<WalletHistoryItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            context.tr(LocaleKeys.noPreviousTransactions),
            style: TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) const CustomSizedBox(height: 12),
          WalletHistoryItemCard(item: items[i]),
        ],
      ],
    );
  }
}

class WalletHistoryItemCard extends StatelessWidget {
  const WalletHistoryItemCard({super.key, required this.item});

  final WalletHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final credit = item.isCredit;
    final amount = item.amount;
    final whole = amount == null || amount == amount.roundToDouble();
    final amountText = amount == null
        ? '...'
        : whole
            ? amount.toInt().toString()
            : amount.toString();
    final accent = credit ? AppColors.mainColor : AppColors.redColor;
    final method = methodName(context, item.paymentMethod);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
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
          // Direction chip — green down arrow for credits, red up for debits.
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accent, accent.withValues(alpha: 0.55)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.30),
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
                            : (credit
                                ? context.tr(LocaleKeys.deposit)
                                : context.tr(LocaleKeys.debit)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                        ).copyWith(color: AppColors.text),
                      ),
                    ),
                    const SizedBox(width: 10),
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
                    StatusPill(status: item.status, label: item.statusLabel),
                  ],
                ),
                if (method.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.payments_outlined,
                        size: 12,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        method,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ],
                if ((item.receiptUrl?.trim().isNotEmpty ?? false)) ...[
                  const SizedBox(height: 8),
                  Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: InkWell(
                      onTap: () => showReceiptSheet(context, item.receiptUrl!),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              AppColors.mainColor.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.receipt_long_rounded,
                              size: 15,
                              color: AppColors.mainColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              context.tr(LocaleKeys.viewReceipt),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                              ),
                            ),
                          ],
                        ),
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

/// Status pill colored by normalized status group.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status, required this.label});

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
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
