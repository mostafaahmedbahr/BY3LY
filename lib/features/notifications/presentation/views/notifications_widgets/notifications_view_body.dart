import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 
'notifications_list.dart';
import 
'notifications_loading.dart';

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
            padding:   EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                _ReadStatusFilter(),
                SizedBox(height: 20),
                const Expanded(child: NotificationsLoading()),
              ],
            ),
          );
        }
        if (state is GetNotificationsDataError &&
            cubit.notificationsList.isEmpty) {
          return Padding(

            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                _ReadStatusFilter(),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (cubit.unreadCount > 0)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                      onPressed: () => cubit.markAllAsRead(),
                      child: Text(
                        context.tr(LocaleKeys.markAllAsRead),
                        style: const TextStyle(
                          color: AppColors.mainColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ),
                ),
              const SizedBox(height: 4),
              _ReadStatusFilter(),
              const SizedBox(height: 8),
              const Expanded(child: NotificationsList()),
            ],
          ),
        );
      },
    );
  }
}

/// Read-status filter chips (All / Read / Unread) applied
/// client-side on top of the loaded notifications.
class _ReadStatusFilter extends StatelessWidget {
  const _ReadStatusFilter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsStates>(
      builder: (context, state) {
        final cubit = NotificationsCubit.get(context);
        final options = [
          ('all', context.tr(LocaleKeys.filterAll)),
          ('read', context.tr(LocaleKeys.filterRead)),
          ('unread', context.tr(LocaleKeys.filterUnread)),
        ];
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
              for (final o in options)
                ChoiceChip(
                  label: Text(o.$2),
                  selected: cubit.readFilter == o.$1,
                  onSelected: (_) =>
                      cubit.setReadFilter(o.$1),
                  selectedColor: AppColors.mainColor,
                  backgroundColor:
                      const Color(0xffF1F3F5),
                  labelStyle: TextStyle(
                    color: cubit.readFilter == o.$1
                        ? Colors.white
                        : const Color(0xff1F2937),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: cubit.readFilter == o.$1
                          ? AppColors.mainColor
                          : const Color(0xffD0D0D0),
                    ),
                  ),
                  showCheckmark: false,
                ),
            ],
          );
      },
    );
  }
}
