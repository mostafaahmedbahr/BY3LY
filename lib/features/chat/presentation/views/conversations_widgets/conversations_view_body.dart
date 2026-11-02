import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/main_importants.dart';

import '../../view_model/chat_states.dart';
import '../../view_model/conversations_cubit.dart';
import '../chat_helpers.dart';
import 'conversation_list_item.dart';
import 'conversations_loading_empty.dart';

class ConversationsViewBody extends StatefulWidget {
  const ConversationsViewBody({super.key});

  @override
  State<ConversationsViewBody> createState() => _ConversationsViewBodyState();
}

class _ConversationsViewBodyState extends State<ConversationsViewBody> {
  @override
  void initState() {
    super.initState();
    final cubit = ConversationsCubit.get(context);
    cubit.startPolling();
    cubit.getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConversationsCubit, ConversationsStates>(
      listener: (context, state) {
        if (state is ConversationDeleteError) {
          Toast.showErrorToast(
            msg: chatErrorText(state.message),
            context: context,
          );
        }
      },
      builder: (context, state) {
        final cubit = ConversationsCubit.get(context);

        if (state is ConversationsLoading && cubit.conversations.isEmpty) {
          return const ConversationsLoadingShimmer();
        }

        if (state is ConversationsError && cubit.conversations.isEmpty) {
          return CustomErrorWidget(
            error: chatErrorText(state.message),
            onTap: () => cubit.getConversations(),
          );
        }

        if (cubit.conversations.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => cubit.getConversations(),
            color: AppColors.accent,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [SizedBox(height: 80), ConversationsEmpty()],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => cubit.refresh(silent: false),
          color: AppColors.accent,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.extentAfter < 320 &&
                  cubit.hasMore &&
                  !cubit.isLoadingMore) {
                cubit.loadMore();
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              itemCount:
                  cubit.conversations.length + (cubit.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= cubit.conversations.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CustomLoading()),
                  );
                }
                final conversation = cubit.conversations[index];
                return ConversationListItem(
                  conversation: conversation,
                  isDeleting:
                      state is ConversationDeleted &&
                      state.conversationId == conversation.id,
                  onTap: () => _openChat(conversation.id),
                  onDelete: () => cubit.deleteConversation(conversation.id),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _openChat(int? conversationId) async {
    final cubit = ConversationsCubit.get(context);
    final conversation = cubit.conversations.firstWhere(
      (item) => item.id == conversationId,
    );
    cubit.markConversationReadLocally(conversationId);
    // The chat screen has its own polling; stop the list's background polling
    // so it doesn't reload conversations (and the badge) while the user types.
    cubit.stopPolling();
    await context.pushNamed(
      Routes.chatView,
      arguments: {'conversation': conversation},
    );
    if (!mounted) return;
    cubit.startPolling();
    cubit.refresh(silent: true);
  }
}
