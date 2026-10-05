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
      title: "مسح الإشعارات",
      message: "سيتم حذف كل الإشعارات نهائيًا؟",
      icon: Icons.delete_sweep_outlined,
    );
    if (confirmed && context.mounted) {
      cubit.deleteAllNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title: Text(context.tr(LocaleKeys.notifications),style: const TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold
        ),),
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
                      tooltip: "تعليم الكل كمقروء",
                      onPressed: () => cubit.markAllAsRead(),
                      icon: const Icon(
                        Icons.done_all_rounded,
                        color: AppColors.mainColor,
                      ),
                    );
                  },
                ),
                IconButton(
                  tooltip: "مسح الكل",
                  onPressed: () => _confirmClearAll(context),
                  icon: const Icon(
                    Icons.delete_sweep_outlined,
                    color: AppColors.mainColor,
                  ),
                ),
              ],
      ),
      body: GuestGuard.isGuest
          ? const GuestPlaceholder()
          : const NotificationsViewBody(),
    ));
  }
}
