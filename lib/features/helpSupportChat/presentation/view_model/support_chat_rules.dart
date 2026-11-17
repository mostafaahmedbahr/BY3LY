import 'dart:io';

import '../../data/models/support_models.dart';

/// Single source of truth for support-chat-side pure helpers.
/// Mirrors ChatRules but typed to [SupportMessageModel].
class SupportChatRules {
  SupportChatRules._();

  /// Max file size the server accepts for an image (5 MiB).
  static const int maxImageBytes = 5 * 1024 * 1024;

  /// Image extensions the backend accepts.
  static const Set<String> allowedImageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'webp',
  };

  /// Returns the lower-cased extension of [path], without the leading dot.
  static String imageExtension(String path) {
    final lastDot = path.lastIndexOf('.');
    if (lastDot == -1 || lastDot == path.length - 1) return '';
    return path.substring(lastDot + 1).toLowerCase();
  }

  static bool isAllowedImageExtension(String path) =>
      allowedImageExtensions.contains(imageExtension(path));

  static bool isAllowedImageSize(int bytes) =>
      bytes >= 0 && bytes <= maxImageBytes;

  /// Sorts messages so the newest (highest id) is first.
  static List<SupportMessageModel> sortedMessagesDesc(
    List<SupportMessageModel> items,
  ) {
    final copy = [...items];
    copy.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    return copy;
  }

  /// True when [a] and [b] contain the same message ids in the same order.
  static bool sameMessageIds(
    List<SupportMessageModel> a,
    List<SupportMessageModel> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  /// Whether more history is available based on the server's [total] and how
  /// many messages are currently loaded.
  static bool hasMoreOlder(
    List<SupportMessageModel> currentList,
    int? total,
    int pageSize,
  ) {
    if (total == null) return currentList.length >= pageSize;
    return currentList.length < total;
  }

  /// Returns only messages from [incoming] whose id is NOT in [existing].
  static List<SupportMessageModel> filterNewMessages(
    List<SupportMessageModel> incoming,
    List<SupportMessageModel> existing,
  ) {
    final existingIds = existing.map((e) => e.id).toSet();
    return incoming
        .where((item) => item.id == null || !existingIds.contains(item.id))
        .toList();
  }

  /// Marks every message as read (used after a successful bulk read).
  static List<SupportMessageModel> markAllMessagesRead(
    List<SupportMessageModel> messages,
  ) => [
    for (final m in messages)
      if (m.isRead == true) m else m.copyWith(isRead: true),
  ];

  /// True when the file exists and satisfies the size limit.
  static Future<bool> validateImageFile(String path) async {
    final file = File(path);
    if (!await file.exists()) return false;
    final size = await file.length();
    return isAllowedImageSize(size);
  }
}
