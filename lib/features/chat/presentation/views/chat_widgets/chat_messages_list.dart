import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../data/models/chat_models.dart';
import '../../view_model/chat_cubit.dart';
import '../../view_model/chat_states.dart';
import '../chat_helpers.dart';
import 'chat_message_bubble.dart';

class ChatMessagesList extends StatelessWidget {
  const ChatMessagesList({
    super.key,
    required this.scrollController,
    required this.onMessageLongPress,
  });

  final ScrollController scrollController;
  /// Called when the user long-presses a message. The view is responsible
  /// for showing an action sheet (copy / delete / cancel).
  final ValueChanged<ChatMessageModel> onMessageLongPress;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatStates>(
      builder: (context, state) {
        final cubit = ChatCubit.get(context);
        final messages = cubit.messages;

        if (state is ChatMessagesLoading && messages.isEmpty) {
          return const CustomLoading();
        }

        if (state is ChatMessagesError && messages.isEmpty) {
          return CustomErrorWidget(
            error: chatErrorText(state.message),
            onTap: cubit.loadMessages,
          );
        }

        if (messages.isEmpty) {
          return _ChatEmpty();
        }

        final showOlderLoader = cubit.isLoadingOlder;
        return ListView.builder(
          reverse: true,
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          itemCount: messages.length + (showOlderLoader ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= messages.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.2),
                  ),
                ),
              );
            }
            final message = messages[index];
            return ChatMessageBubble(
              // Stable identity: prevents the reversed list from reusing a
              // bubble element for a different message when new ones arrive.
              key: ValueKey(message.id ?? 'index_$index'),
              message: message,
              onLongPress: () => onMessageLongPress(message),
              onImageTap: message.isImage
                  ? () => showChatImage(context, message.image ?? '')
                  : null,
            );
          },
        );
      },
    );
  }
}

class _ChatEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 84,
              width: 84,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 40,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.tr(LocaleKeys.noMessagesYet),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.tr(LocaleKeys.startTheConversation),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
