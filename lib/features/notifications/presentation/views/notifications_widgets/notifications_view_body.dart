import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifications_buttons_types.dart';
import 'notifications_list.dart';

class NotificationsViewBody extends StatefulWidget {
  const NotificationsViewBody({super.key});

  @override
  State<NotificationsViewBody> createState() =>
      _NotificationsViewBodyState();
}

class _NotificationsViewBodyState extends State<NotificationsViewBody> {
  @override
  void initState() {
    super.initState();
    // The startup call may have run before login, refetch if empty.
    final cubit = NotificationsCubit.get(context);
    if (cubit.notificationsList.isEmpty) {
      cubit.getNotificationsData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsStates>(
      builder: (context, state) {
        final cubit = NotificationsCubit.get(context);

        if (state is GetNotificationsDataLoading &&
            cubit.notificationsList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                NotificationsButtonsTypes(),
                SizedBox(height: 20),
                Expanded(child: CustomLoading()),
              ],
            ),
          );
        }
        if (state is GetNotificationsDataError &&
            cubit.notificationsList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const NotificationsButtonsTypes(),
                const SizedBox(height: 20),
                Expanded(
                  child: CustomErrorWidget(
                    error: state.message,
                    onTap: () => cubit.refresh(),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(child: NotificationsButtonsTypes()),
                  if (cubit.unreadCount > 0)
                    TextButton(
                      onPressed: () => cubit.markAllAsRead(),
                      child: const Text(
                        "تعليم الكل كمقروء",
                        style: TextStyle(
                          color: AppColors.mainColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              const Expanded(child: NotificationsList()),
            ],
          ),
        );
      },
    );
  }
}
