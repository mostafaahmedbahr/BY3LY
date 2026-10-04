import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Unified confirmation dialog used across the whole app.
///
/// Same modern look everywhere, only the content changes:
/// ```dart
/// final confirmed = await AppConfirmDialog.show(
///   context,
///   title: context.tr(LocaleKeys.comparison),
///   message: context.tr(LocaleKeys.clearCompareConfirm),
/// );
/// if (confirmed) { ... }
/// ```
class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.icon = Icons.delete_outline_rounded,
    this.accentColor = AppColors.redColor,
  });

  final String title;
  final String message;
  final String? confirmText;
  final IconData icon;
  final Color accentColor;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    IconData icon = Icons.delete_outline_rounded,
    Color accentColor = AppColors.redColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        icon: icon,
        accentColor: accentColor,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.greyColor,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      context.tr(LocaleKeys.cancel),
                      style: const TextStyle(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Text(
                      confirmText ?? context.tr(LocaleKeys.delete),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
