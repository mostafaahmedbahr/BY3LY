import 'package:easy_localization/easy_localization.dart';

import '../../../../lang/locale_keys.dart';
import '../../data/models/chat_models.dart';

String _two(int value) => value.toString().padLeft(2, '0');

String formatChatClock(String? isoDate) {
  final date = isoDate == null ? null : DateTime.tryParse(isoDate)?.toLocal();
  if (date == null) return '';
  return '${_two(date.hour)}:${_two(date.minute)}';
}

String formatChatDate(String? isoDate) {
  final date = isoDate == null ? null : DateTime.tryParse(isoDate)?.toLocal();
  if (date == null) return '';
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(date.year, date.month, date.day);
  final difference = today.difference(day).inDays;
  if (difference == 0) return formatChatClock(isoDate);
  if (difference == 1) return LocaleKeys.yesterday.tr();
  return '${_two(date.day)}/${_two(date.month)}/${date.year}';
}

String formatMessageTimestamp(String? isoDate) {
  final date = isoDate == null ? null : DateTime.tryParse(isoDate)?.toLocal();
  if (date == null) return '';
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(date.year, date.month, date.day);
  if (today == day) return formatChatClock(isoDate);
  return '${_two(date.day)}/${_two(date.month)} ${formatChatClock(isoDate)}';
}

/// The API returns Arabic messages, while transport failures are stored as
/// locale keys (e.g. `connectionTimeOut`). `tr()` keeps server messages
/// untouched and translates the known keys.
String chatErrorText(String message) => message.tr();

String chatMessagePreview(ChatMessageModel? message) {
  if (message == null) return '';
  if (message.isDeleted == true) return LocaleKeys.deletedMessage.tr();
  if (message.type == 'image') return LocaleKeys.photo.tr();
  final body = message.body?.trim() ?? '';
  return body;
}
