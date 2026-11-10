import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/notifications/data/models/notifications_model.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:flutter/material.dart';

/// Premium notification row: bell chip (green filled when unread),
/// title in bold dark, body 2-line preview, friendly date/time.
class NotificationsListItem extends StatelessWidget {
  const NotificationsListItem({super.key, required this.notification});

  final Notifications notification;

  /// Tolerant best-effort date/time formatting. Falls back to the raw
  /// string when the server's format can't be parsed.
  String _formatDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    final trimmed = raw.trim();
    final parsed = DateTime.tryParse(trimmed);
    if (parsed == null) return trimmed;
    final local = parsed.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final mo = local.month.toString().padLeft(2, '0');
    return '$d/$mo · $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final unread = notification.isRead != true;
    return InkWell(
      onTap: () {
        if (unread) {
          NotificationsCubit.get(context).markAsRead(notification.id);
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: unread
              ? AppColors.mainColor.withValues(alpha: 0.07)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: unread
                ? AppColors.mainColor.withValues(alpha: 0.30)
                : AppColors.border,
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bell chip — green filled when unread, soft border when read.
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: unread
                    ? AppColors.mainColor
                    : AppColors.mainColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                unread
                    ? Icons.notifications_rounded
                    : Icons.notifications_outlined,
                size: 21,
                color: unread ? Colors.white : AppColors.mainColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight:
                                unread ? FontWeight.w800 : FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (unread)
                        Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: AppColors.redColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.surface,
                              width: 1.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.45,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(notification.createdAt),
                    style: TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textSecondary.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
