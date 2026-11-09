import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/addBalance/presentation/view_model/add_balance_config.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bottom sheet with the bank account details customers paste into their
/// banking app for an Instapay transfer (manual review by the team).
class InstapaySheet extends StatelessWidget {
  const InstapaySheet({super.key});

  /// Opens the sheet. Barrier-dismissible, drag-to-close enabled.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const SafeArea(
        top: false,
        child: InstapaySheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            context.tr(LocaleKeys.copyThis),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(
            title: context.tr(LocaleKeys.bankName),
            subtitle: context.tr(LocaleKeys.bankDes),
            copyLabel: context.tr(LocaleKeys.bankDes),
            copiedMessage: context.tr(LocaleKeys.copyBankName),
          ),
          _Divider(),
          _InfoRow(
            title: context.tr(LocaleKeys.accountNumber),
            subtitle: AddBalanceConfig.accountNumber,
            copyLabel: AddBalanceConfig.accountNumber,
            copiedMessage: context.tr(LocaleKeys.copyAccountNumber),
          ),
          _Divider(),
          _InfoRow(
            title: context.tr(LocaleKeys.companyName),
            subtitle: LocaleKeys.appName.tr(),
            copyLabel: LocaleKeys.appName.tr(),
            copiedMessage: context.tr(LocaleKeys.copyCompanyName),
          ),
        ],
      ),
    );
  }
}

/// One labeled row with a copy button on the trailing side.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.title,
    required this.subtitle,
    required this.copyLabel,
    required this.copiedMessage,
  });

  final String title;
  final String subtitle;
  final String copyLabel;
  final String copiedMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'نسخ',
            icon: const Icon(Icons.copy_rounded),
            color: AppColors.mainColor,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: copyLabel));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(copiedMessage)),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Soft divider between [_InfoRow]s.
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        color: AppColors.border.withValues(alpha: 0.6),
      ),
    );
  }
}
