import 'package:by3ly/core/shared_widgets/app_confirm_dialog.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../data/models/chat_models.dart';
import '../chat_helpers.dart';

class ConversationListItem extends StatelessWidget {
  const ConversationListItem({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onDelete,
    this.isDeleting = false,
  });

  final ConversationModel conversation;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final unread = conversation.unreadCount ?? 0;
    final otherUser = conversation.otherUser;
    final last = conversation.lastMessage;
    final product = conversation.product;
    final isUnread = unread > 0;

    return Opacity(
      opacity: isDeleting ? 0.45 : 1,
      child: InkWell(
        onTap: isDeleting ? null : onTap,
        onLongPress: isDeleting ? null : () => _confirmDelete(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUnread
                ? AppColors.accent.withValues(alpha: 0.07)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isUnread
                  ? AppColors.accent.withValues(alpha: 0.28)
                  : AppColors.border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: CustomNetWorkImage(
                  imageUrl: otherUser?.image ?? '',
                  raduis: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            otherUser?.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isUnread
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formatChatDate(
                            last?.createdAt ?? conversation.updatedAt,
                          ),
                          style: TextStyle(
                            fontSize: 10.5,
                            color: isUnread
                                ? AppColors.accent
                                : AppColors.textSecondary,
                            fontWeight: isUnread
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (last?.isMine == true) ...[
                          Text(
                            '${LocaleKeys.you.tr()} : ',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        Expanded(
                          child: Text(
                            chatMessagePreview(last),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.4,
                              color: isUnread
                                  ? AppColors.text
                                  : AppColors.textSecondary,
                              fontWeight: isUnread
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            margin: const EdgeInsetsDirectional.only(start: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            constraints: const BoxConstraints(minWidth: 20),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              unread > 99 ? '99+' : '$unread',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (product != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CustomNetWorkImage(
                                  imageUrl: product.image ?? '',
                                  raduis: 7,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                product.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            if (product.priceLabel.isNotEmpty)
                              Text(
                                '${product.priceLabel} ${LocaleKeys.currencyEgp.tr()}',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: LocaleKeys.deleteConversation.tr(),
      message: LocaleKeys.deleteConversationConfirm.tr(),
      confirmText: LocaleKeys.delete.tr(),
      icon: Icons.delete_outline_rounded,
    );
    if (!confirmed || !context.mounted) return;
    onDelete();
  }
}
