import 'package:by3ly/main_importants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../data/models/chat_models.dart';
import '../chat_helpers.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.onLongPress,
    required this.onImageTap,
  });

  final ChatMessageModel message;
  final VoidCallback? onLongPress;
  final VoidCallback? onImageTap;

  bool get _isMine => message.isMine == true;
  bool get _isDeleted => message.isDeleted == true;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = _isMine ? AppColors.accent : AppColors.surfaceVariant;
    final textColor = _isMine ? Colors.white : AppColors.text;

    return Align(
      alignment: _isMine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: GestureDetector(
        onLongPress: _isDeleted ? null : onLongPress,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: EdgeInsets.all(message.isImage && !_isDeleted ? 4 : 10),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadiusDirectional.only(
              topStart: const Radius.circular(16),
              topEnd: const Radius.circular(16),
              bottomStart: Radius.circular(_isMine ? 16 : 4),
              bottomEnd: Radius.circular(_isMine ? 4 : 16),
            ),
            border: Border.all(
              color: _isMine
                  ? AppColors.accent
                  : AppColors.border.withValues(alpha: 0.7),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isDeleted)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.block_rounded,
                        size: 14,
                        color: textColor.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          context.tr(LocaleKeys.deletedMessage),
                          style: TextStyle(
                            fontSize: 12.5,
                            fontStyle: FontStyle.italic,
                            color: textColor.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                if (message.isImage)
                  GestureDetector(
                    onTap: onImageTap,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 220,
                        height: 180,
                        child: CachedNetworkImage(
                          imageUrl: message.image ?? '',
                          fit: BoxFit.cover,
                          placeholder: (_, _) =>
                              const Center(child: CustomLoading()),
                          errorWidget: (_, _, _) =>
                              const Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                  ),
                if ((message.body?.trim().isNotEmpty ?? false))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      message.body!,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: textColor,
                      ),
                    ),
                  ),
              ],
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 4,
                  end: 2,
                  top: 3,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatMessageTimestamp(message.createdAt),
                      style: TextStyle(
                        fontSize: 9.5,
                        color: textColor.withValues(alpha: 0.75),
                      ),
                    ),
                    if (_isMine && !_isDeleted) ...[
                      const SizedBox(width: 4),
                      Icon(
                        message.isRead == true
                            ? Icons.done_all_rounded
                            : Icons.done_rounded,
                        size: 13,
                        color: message.isRead == true
                            ? Colors.lightBlueAccent
                            : textColor.withValues(alpha: 0.75),
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
}

void showChatImage(BuildContext context, String imageUrl) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => Navigator.pop(dialogContext),
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 4,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            placeholder: (_, _) => const CustomLoading(),
            errorWidget: (_, _, _) =>
                const Icon(Icons.broken_image_outlined, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
