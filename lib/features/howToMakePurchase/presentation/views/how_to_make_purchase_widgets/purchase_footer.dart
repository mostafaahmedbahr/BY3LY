import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/helpSupportChat/presentation/views/help_support_chat_view.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

/// Footer beneath the instructions: optional last-updated line
/// and a 'contact support' shortcut.
class PurchaseFooter extends StatelessWidget {
  const PurchaseFooter({super.key, this.updatedAt});

  /// Raw `updated_at` string from the server (ISO-ish formats tolerated).
  final String? updatedAt;

  /// Formats a best-effort readable date. Unknown formats are shown as-is.
  String _formatUpdated(String raw) {
    final parsed = DateTime.tryParse(raw.trim());
    if (parsed == null) return raw;
    final y = parsed.year.toString().padLeft(4, '0');
    final m = parsed.month.toString().padLeft(2, '0');
    final d = parsed.day.toString().padLeft(2, '0');
    return '$d / $m / $y';
  }

  @override
  Widget build(BuildContext context) {
    final trimmed = updatedAt?.trim();
    final showUpdated = trimmed != null && trimmed.isNotEmpty;
    return Column(
      children: [
        const SizedBox(height: 18),
        Divider(height: 1, color: AppColors.border),
        const SizedBox(height: 14),
        if (showUpdated)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '${context.tr(LocaleKeys.lastUpdated)}: ${_formatUpdated(trimmed)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const HelpSupportChatView(),
                ),
              );
            },
            icon: const Icon(Icons.headset_mic_rounded, size: 19),
            label: Text(context.tr(LocaleKeys.contactSupport)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.mainColor,
              side: BorderSide(
                color: AppColors.mainColor.withValues(alpha: 0.45),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
