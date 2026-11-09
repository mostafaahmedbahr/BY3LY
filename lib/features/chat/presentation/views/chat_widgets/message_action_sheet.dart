import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/chat_models.dart';
import 'action_sheet_item.dart';


/// Bottom sheet with actions for a long-pressed message: copy / delete /
/// cancel. The caller decides what to do with the chosen action via the
/// provided callbacks.
class MessageActionSheet extends StatelessWidget {
  const MessageActionSheet({
    super.key,
    required this.message,
    required this.onCopy,
    required this.onDelete,
    required this.onClose,
  });

  final ChatMessageModel message;
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine == true;
    final isDeleted = message.isDeleted == true;
    final canCopy = !isDeleted && (message.body?.trim().isNotEmpty ?? false);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          if (canCopy && onCopy != null)
            ActionSheetItem(
              icon: Icons.content_copy_rounded,
              label: context.tr(LocaleKeys.copy),
              onTap: () {
                Navigator.pop(context);
                onCopy!();
              },
            ),
          if (isMine && !isDeleted && onDelete != null)
            ActionSheetItem(
              icon: Icons.delete_outline_rounded,
              label: context.tr(LocaleKeys.deleteMessage),
              iconColor: AppColors.redColor,
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                onDelete!();
              },
            ),
          const SizedBox(height: 4),
          ActionSheetItem(
            icon: Icons.close_rounded,
            label: context.tr(LocaleKeys.cancel),
            onTap: onClose,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Convenience helper that opens the message action sheet with the standard
/// look & feel used across the chat screen.
Future<void> showMessageActionSheet({
  required BuildContext context,
  required ChatMessageModel message,
  required VoidCallback onCopy,
  required VoidCallback onDelete,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => MessageActionSheet(
      message: message,
      onCopy: onCopy,
      onDelete: onDelete,
      onClose: () => Navigator.pop(sheetContext),
    ),
  );
}
