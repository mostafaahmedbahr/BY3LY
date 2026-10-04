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
              : const Color.fromRGBO(248, 248, 248, 1),
          border: Border.all(
            color: unread
                ? AppColors.mainColor.withValues(alpha: 0.25)
                : const Color(0xFFF0F0F0),
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
                    : const Color(0xffE8E8E8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_outlined,
                size: 20,
                color: unread
                    ? Colors.white
                    : const Color(0xff9AA0A6),
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
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: Color(0xff5B6570),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.createdAt ?? '',
                    style: AppStyles.textStyle10W400Green.copyWith(
                      color: const Color(0xff9AA0A6),
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
