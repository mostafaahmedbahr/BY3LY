import 'package:by3ly/core/shared_widgets/app_confirm_dialog.dart';
import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/shared_widgets/no_data_widget.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/notifications/data/models/notifications_model.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_states.dart';
import 'package:by3ly/features/notifications/presentation/views/notifications_widgets/notifications_list_item.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsList extends StatefulWidget {
  const NotificationsList({super.key});

  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (max - current <= 300) {
      NotificationsCubit.get(context)
          .getNotificationsData(loadMore: true);
    }
  }

  Future<void> _confirmDeleteOne(
      BuildContext context, Notifications n) async {
    if (n.id == null) return;
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.tr(LocaleKeys.deleteNotification),
      message: context.tr(LocaleKeys.deleteNotificationConfirm),
    );
    if (confirmed && context.mounted) {
      NotificationsCubit.get(context).deleteNotification(n.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsStates>(
      builder: (context, state) {
        final cubit = NotificationsCubit.get(context);
        final items = cubit.filteredNotifications;

        if (items.isEmpty && !cubit.isLoadingMore) {
          return NoDataWidget(
            image: "assets/images/Validation.svg",
            text: context.tr(LocaleKeys.noNotificationsOfThisType),
          );
        }

        return RefreshIndicator(
          onRefresh: () => cubit.refresh(),
          child: ListView.separated(
            controller: _scrollController,
            itemCount: items.length +
                ((cubit.isLoadingMore ||
                        state
                            is GetNotificationsDataPaginationError)
                    ? 1
                    : 0),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                if (state
                    is GetNotificationsDataPaginationError) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16),
                    child: TextButton(
                      onPressed: () => cubit.getNotificationsData(
                          loadMore: true),
                      child: Text(
                        context.tr(LocaleKeys.retry),
                        style: const TextStyle(
                            color: AppColors.mainColor),
                      ),
                    ),
                  );
                }
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5),
                    ),
                  ),
                );
              }
              final n = items[index];
              return Dismissible(
                key: ValueKey(
                    'notif_${n.id ?? index}_${n.createdAt ?? ''}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.redColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                confirmDismiss: (_) async {
                  await _confirmDeleteOne(context, n);
                  return false;
                },
                child: NotificationsListItem(notification: n),
              );
            },
            separatorBuilder: (context, index) {
              return const CustomSizedBox(height: 12);
            },
          ),
        );
      },
    );
  }
}
