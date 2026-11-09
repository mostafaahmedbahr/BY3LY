import 'dart:io';

import '../../data/models/chat_models.dart';

/// Single source of truth for chat-side pure helpers.
///
/// These were previously private methods inside [ChatCubit]; they live here
/// as plain functions so they can be unit-tested and reused.
class ChatRules {
  ChatRules._();

  /// Max file size the server accepts for a chat image (5 MiB).
  static const int maxImageBytes = 5 * 1024 * 1024;

  /// Image extensions the backend accepts.
  static const Set<String> allowedImageExtensions = {'jpg', 'jpeg', 'png', 'webp'};

  /// Returns the lower-cased extension of [path], without the leading dot.
  /// Returns an empty string when there is no extension.
  static String imageExtension(String path) {
    final lastDot = path.lastIndexOf('.');
    if (lastDot == -1 || lastDot == path.length - 1) return '';
    return path.substring(lastDot + 1).toLowerCase();
  }

  /// True when [path] has an allowed image extension.
  static bool isAllowedImageExtension(String path) =>
      allowedImageExtensions.contains(imageExtension(path));

  /// True when [bytes] fits the server's per-image limit.
  static bool isAllowedImageSize(int bytes) => bytes >= 0 && bytes <= maxImageBytes;

  /// Sorts messages so the newest (highest id) is first.
  static List<ChatMessageModel> sortedMessagesDesc(
    List<ChatMessageModel> items,
  ) {
    final copy = [...items];
    copy.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    return copy;
  }

  /// True when [a] and [b] contain the same message ids in the same order.
  static bool sameMessageIds(
    List<ChatMessageModel> a,
    List<ChatMessageModel> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  /// Decides whether more history is available based on the server's [total]
  /// and how many messages are currently loaded.
  static bool hasMoreOlder(
    List<ChatMessageModel> currentList,
    int? total,
    int pageSize,
  ) {
    if (total == null) return currentList.length >= pageSize;
    return currentList.length < total;
  }

  /// Returns only the messages from [incoming] whose id is NOT already in
  /// [existing]. Order of [incoming] is preserved.
  static List<ChatMessageModel> filterNewMessages(
    List<ChatMessageModel> incoming,
    List<ChatMessageModel> existing,
  ) {
    final existingIds = existing.map((e) => e.id).toSet();
    return incoming
        .where((item) => item.id == null || !existingIds.contains(item.id))
        .toList();
  }

  /// Marks every message as read (used after a successful bulk read).
  static List<ChatMessageModel> markAllMessagesRead(
    List<ChatMessageModel> messages,
  ) => [
        for (final m in messages)
          if (m.isRead == true) m else m.copyWith(isRead: true),
      ];

  /// Returns only the file when it exists and satisfies the size limit,
  /// or null otherwise; used by the image send flow.
  static Future<bool> validateImageFile(String path) async {
    final file = File(path);
    if (!await file.exists()) return false;
    final size = await file.length();
    return isAllowedImageSize(size);
  }
}
