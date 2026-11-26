import 'package:by3ly/features/chat/presentation/view_model/chat_states.dart';
import 'package:by3ly/features/chat/presentation/views/chat_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatView.shouldRebuild', () {
    test('message traffic does not rebuild the whole scaffold', () {
      final previous = ChatInitState();
      expect(ChatView.shouldRebuild(previous, ChatMessagesLoading()), isFalse);
      expect(
        ChatView.shouldRebuild(previous, ChatMessagesSuccess([])),
        isFalse,
      );
      expect(
        ChatView.shouldRebuild(previous, ChatReceivingNewMessages([])),
        isFalse,
      );
      expect(ChatView.shouldRebuild(previous, ChatMarkedRead(3)), isFalse);
    });

    test('scaffold-affecting states still rebuild it', () {
      final previous = ChatInitState();
      expect(
        ChatView.shouldRebuild(previous, ChatConversationDeleting()),
        isTrue,
      );
      expect(
        ChatView.shouldRebuild(previous, ChatConversationDeleted()),
        isTrue,
      );
      expect(ChatView.shouldRebuild(previous, ChatMessageSending()), isTrue);
      expect(ChatView.shouldRebuild(previous, ChatImageSending()), isTrue);
      expect(
        ChatView.shouldRebuild(previous, ChatMessageSendError('x')),
        isTrue,
      );
    });

    test('leaving the deleting state hides the progress bar', () {
      expect(
        ChatView.shouldRebuild(
          ChatConversationDeleting(),
          ChatReceivingNewMessages([]),
        ),
        isTrue,
      );
    });
  });
}
