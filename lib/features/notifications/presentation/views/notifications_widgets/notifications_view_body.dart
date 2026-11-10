import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_states.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../main_importants.dart';
import 'notifications_list.dart';
import 'notifications_loading.dart';

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
    // Fetch fresh data every time the screen opens, not just when the list
    // is empty — otherwise a notification received while the app was
    // backgrounded never appears in the list.
    final cubit = NotificationsCubit.get(context);
    if (cubit.shouldRefreshOnOpen) {
      cubit.getNotificationsData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsStates>(
      builder: (context, state) {
        final cubit = NotificationsCubit.get(context);
        final hadCachedData = cubit.notificationsList.isNotEmpty;

        if (state is GetNotificationsDataLoading && !hadCachedData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  SizedBox(height: 6.h),
                const _ReadStatusFilter(),
                  SizedBox(height: 18.h),
                const Expanded(child: NotificationsLoading()),
              ],
            ),
          );
        }
        if (state is GetNotificationsDataError && !hadCachedData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  SizedBox(height: 6.h),
                const _ReadStatusFilter(),
                  SizedBox(height: 18.h),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (cubit.unreadCount > 0)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: () => cubit.markAllAsRead(),
                    icon: const Icon(
                      Icons.done_all_rounded,
                      size: 18,
                      color: AppColors.mainColor,
                    ),
                    label: Text(
                      context.tr(LocaleKeys.markAllAsRead),
                      style: const TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
              const _ReadStatusFilter(),
                SizedBox(height: 12.h),
              const Expanded(child: NotificationsList()),
            ],
          ),
        );
      },
    );
  }
}

/// Premium read-status filter chips (All / Read / Unread) with
/// per-chip counts derived from the loaded notifications.
class _ReadStatusFilter extends StatelessWidget {
  const _ReadStatusFilter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsStates>(
      builder: (context, state) {
        final cubit = NotificationsCubit.get(context);
        final allCount = cubit.notificationsList.length;
        final readCount =
            cubit.notificationsList.where((n) => n.isRead == true).length;
        final unreadCount = allCount - readCount;

        final options = [
          ('all', context.tr(LocaleKeys.filterAll), allCount),
          ('read', context.tr(LocaleKeys.filterRead), readCount),
          ('unread', context.tr(LocaleKeys.filterUnread), unreadCount),
        ];

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              _FilterChip(
                label: option.$2,
                count: option.$3,
                selected: cubit.readFilter == option.$1,
                onTap: () => cubit.setReadFilter(option.$1),
              ),
          ],
        );
      },
    );
  }
}

/// Premium pill chip: white inactive / brand-green filled active,
/// always with a count badge.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppColors.text;
    final countFg =
        selected ? AppColors.yellowColor : AppColors.mainColor;

    return Material(
      color: selected ? AppColors.mainColor : AppColors.surface,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? AppColors.mainColor : AppColors.border,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: countFg.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: countFg,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
