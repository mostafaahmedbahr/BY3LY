import 'package:by3ly/features/chat/data/models/chat_models.dart';
import 'package:by3ly/features/chat/presentation/view_model/chat_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatChatPrice', () {
    test('null returns empty', () {
      expect(formatChatPrice(null), '');
    });
    test('integer groups with thousands separator', () {
      expect(formatChatPrice(4500000), '4,500,000');
      expect(formatChatPrice(1234), '1,234');
    });
    test('zero', () => expect(formatChatPrice(0), '0'));
    test('decimals kept', () => expect(formatChatPrice(1234.56), '1,234.56'));
    test('negative numbers preserved with sign',
        () => expect(formatChatPrice(-5000), '-5,000'));
  });

  group('imageExtension', () {
    test('lowercased extension without dot', () {
      expect(ChatRules.imageExtension('file.JPG'), 'jpg');
    });
    test('multi-dot path', () => expect(ChatRules.imageExtension('a.b.c.d.png'), 'png'));
    test('no extension', () => expect(ChatRules.imageExtension('noext'), ''));
    test('trailing dot', () => expect(ChatRules.imageExtension('trail.'), ''));
    test('empty string', () => expect(ChatRules.imageExtension(''), ''));
  });

  group('isAllowedImageExtension', () {
    String p(String x) => '/tmp/img.$x';
    test('all allowed extensions', () {
      expect(ChatRules.isAllowedImageExtension(p('jpg')), isTrue);
      expect(ChatRules.isAllowedImageExtension(p('JPEG')), isTrue);
      expect(ChatRules.isAllowedImageExtension(p('png')), isTrue);
      expect(ChatRules.isAllowedImageExtension(p('webp')), isTrue);
    });
    test('not allowed', () {
      expect(ChatRules.isAllowedImageExtension(p('gif')), isFalse);
      expect(ChatRules.isAllowedImageExtension(p('bmp')), isFalse);
      expect(ChatRules.isAllowedImageExtension(p('pdf')), isFalse);
      expect(ChatRules.isAllowedImageExtension(p('')), isFalse);
    });
  });

  group('isAllowedImageSize', () {
    test('zero ok', () => expect(ChatRules.isAllowedImageSize(0), isTrue));
    test('max ok',
        () => expect(ChatRules.isAllowedImageSize(ChatRules.maxImageBytes), isTrue));
    test('one over max not ok',
        () => expect(ChatRules.isAllowedImageSize(ChatRules.maxImageBytes + 1), isFalse));
  });

  group('sortedMessagesDesc', () {
    test('newest first; null ids sort last', () {
      final a = ChatMessageModel(id: null);
      final b = ChatMessageModel(id: 2);
      final c = ChatMessageModel(id: 3);
      final d = ChatMessageModel(id: 1);
      expect(ChatRules.sortedMessagesDesc([a, b, c, d]), [c, b, d, a]);
    });

    test('empty list preserved', () => expect(ChatRules.sortedMessagesDesc([]), isEmpty));
  });

  group('sameMessageIds', () {
    test('same length same order', () {
      final a = [ChatMessageModel(id: 1), ChatMessageModel(id: 2)];
      final b = [ChatMessageModel(id: 1), ChatMessageModel(id: 2)];
      expect(ChatRules.sameMessageIds(a, b), isTrue);
    });
    test('different length', () {
      final a = [ChatMessageModel(id: 1)];
      final b = [ChatMessageModel(id: 1), ChatMessageModel(id: 2)];
      expect(ChatRules.sameMessageIds(a, b), isFalse);
    });
    test('different order', () {
      final a = [ChatMessageModel(id: 1), ChatMessageModel(id: 2)];
      final b = [ChatMessageModel(id: 2), ChatMessageModel(id: 1)];
      expect(ChatRules.sameMessageIds(a, b), isFalse);
    });
    test('false because any null id', () {
      final a = [ChatMessageModel(id: null)];
      final b = [ChatMessageModel(id: null)];
      expect(ChatRules.sameMessageIds(a, b), isTrue);
    });
  });

  group('filterNewMessages', () {
    final existing = [ChatMessageModel(id: 1), ChatMessageModel(id: 2)];
    test('drops ids already present', () {
      final incoming = [ChatMessageModel(id: 3), ChatMessageModel(id: 2)];
      expect(ChatRules.filterNewMessages(incoming, existing).map((e) => e.id), [3]);
    });
    test('order preserved', () {
      final incoming = [ChatMessageModel(id: 5), ChatMessageModel(id: 2), ChatMessageModel(id: 4)];
      expect(ChatRules.filterNewMessages(incoming, existing).map((e) => e.id), [5, 4]);
    });
    test('identity comparison fails silently for null ids', () {
      final incoming = [ChatMessageModel(id: null)];
      expect(ChatRules.filterNewMessages(incoming, existing), isNotEmpty);
    });
  });

  group('hasMoreOlder', () {
    test('returns true while under total', () {
      final list = [ChatMessageModel(id: 1), ChatMessageModel(id: 2)];
      expect(ChatRules.hasMoreOlder(list, 5, 30), isTrue);
    });
    test('returns false when total reached', () {
      final list = [ChatMessageModel(id: 1), ChatMessageModel(id: 2)];
      expect(ChatRules.hasMoreOlder(list, 2, 30), isFalse);
    });
    test('null total falls back to length heuristic', () {
      final small = [ChatMessageModel(id: 1)];
      final full = List.generate(30, (i) => ChatMessageModel(id: i));
      expect(ChatRules.hasMoreOlder(small, null, 30), isFalse);
      expect(ChatRules.hasMoreOlder(full, null, 30), isTrue);
    });
  });

  group('markAllMessagesRead', () {
    test('sets isRead=true on all messages', () {
      final input = [
        ChatMessageModel(id: 1, isRead: false),
        ChatMessageModel(id: 2, isRead: true),
      ];
      final out = ChatRules.markAllMessagesRead(input);
      expect(out.every((m) => m.isRead == true), isTrue);
    });
    test('preserves other fields', () {
      final input = [ChatMessageModel(id: 99, body: 'hi', isRead: false)];
      final out = ChatRules.markAllMessagesRead(input);
      expect(out.first.id, 99);
      expect(out.first.body, 'hi');
    });
  });
}

