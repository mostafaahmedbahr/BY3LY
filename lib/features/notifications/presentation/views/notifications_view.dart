import 'package:by3ly/core/shared_widgets/app_confirm_dialog.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifications_widgets/notifications_view_body.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  Future<void> _confirmClearAll(BuildContext context) async {
    final cubit = NotificationsCubit.get(context);
    if (cubit.notificationsList.isEmpty) return;
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.tr(LocaleKeys.clearAll),
      message: context.tr(LocaleKeys.deleteAllNotificationsConfirm),
      icon: Icons.delete_sweep_outlined,
    );
    if (confirmed && context.mounted) {
      cubit.deleteAllNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.darkMainColor,
                AppColors.mainColor,
                AppColors.secondColor,
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                context.tr(LocaleKeys.notifications),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
        actions: GuestGuard.isGuest
            ? null
            : [
                BlocBuilder<NotificationsCubit, NotificationsStates>(
                  builder: (context, state) {
                    final cubit = NotificationsCubit.get(context);
                    if (cubit.unreadCount <= 0) {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      tooltip: context.tr(LocaleKeys.markAllAsRead),
                      onPressed: () => cubit.markAllAsRead(),
                      icon: const Icon(
                        Icons.done_all_rounded,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                IconButton(
                  tooltip: context.tr(LocaleKeys.clearAll),
                  onPressed: () => _confirmClearAll(context),
                  icon: const Icon(
                    Icons.delete_sweep_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
      ),
      body: GuestGuard.isGuest
          ? const GuestPlaceholder()
          : const NotificationsViewBody(),
    );
  }
}
