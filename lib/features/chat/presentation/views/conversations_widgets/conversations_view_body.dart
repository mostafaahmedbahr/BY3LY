import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

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
          return _ErrorState(
            error: chatErrorText(state.message),
            onRetry: () => cubit.getConversations(),
          );
        }

        if (cubit.conversations.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => cubit.getConversations(),
            color: AppColors.accent,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 60),
                ConversationsEmpty(),
              ],
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
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
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
    if (conversationId == null) return;
    final cubit = ConversationsCubit.get(context);
    final conversation = cubit.conversations.firstWhere(
      (item) => item.id == conversationId,
    );
    cubit.markConversationReadLocally(conversationId);
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

/// Error state widget shown when loading conversations fails.
class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(
                color: AppColors.redColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 46,
                color: AppColors.redColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.tr(LocaleKeys.errorTitle),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(context.tr(LocaleKeys.retry)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
