import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Small caption shown beneath a server-provided page to say when it was
/// last updated.
///
/// Tolerates any `updated_at` format: tries [DateTime.tryParse] and renders
/// `dd / MM / yyyy`; falls back to the raw string when it isn't parseable.
/// Renders nothing when the string is null/empty.
class LastUpdatedLabel extends StatelessWidget {
  const LastUpdatedLabel({super.key, this.rawUpdatedAt, this.color});

  final String? rawUpdatedAt;
  final Color? color;

  static String format(String raw) {
    final parsed = DateTime.tryParse(raw.trim());
    if (parsed == null) return raw.trim();
    final y = parsed.year.toString().padLeft(4, '0');
    final m = parsed.month.toString().padLeft(2, '0');
    final d = parsed.day.toString().padLeft(2, '0');
    return '$d / $m / $y';
  }

  @override
  Widget build(BuildContext context) {
    final trimmed = rawUpdatedAt?.trim();
    if (trimmed == null || trimmed.isEmpty) return const SizedBox.shrink();
    return Text(
      '${context.tr(LocaleKeys.lastUpdated)}: ${format(trimmed)}',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 11.5,
        color: color ?? Theme.of(context).hintColor,
      ),
    );
  }
}
