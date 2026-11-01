import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/features/notifications/data/models/notifications_model.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:flutter/material.dart';

class NotificationsListItem extends StatelessWidget {
  const NotificationsListItem({super.key, required this.notification});
  final Notifications notification;
  @override
  Widget build(BuildContext context) {
    final unread = notification.isRead != true;
    return InkWell(
      onTap: () {
        if (unread) {
          NotificationsCubit.get(context)
              .markAsRead(notification.id);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: unread
              ? AppColors.mainColor.withValues(alpha: 0.07)
              : AppColors.surfaceVariant,
          border: Border.all(
            color: unread
                ? AppColors.mainColor.withValues(alpha: 0.25)
                : AppColors.border,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: unread
                    ? AppColors.mainColor
                    : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_outlined,
                size: 20,
                color: unread
                    ? Colors.white
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.createdAt ?? '',
                    style: AppStyles.textStyle10W400Green.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (unread)
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: AppColors.mainColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
