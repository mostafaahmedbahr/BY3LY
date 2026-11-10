
import 'package:by3ly/features/notifications/data/models/notifications_model.dart';
import 'package:by3ly/features/notifications/data/repos/notifications_repos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/guest_guard.dart';
import 'notifications_states.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  NotificationsCubit(this.notificationsRepos) : super(NotificationsInitState()) {
    // FCM handling in AppNotifications is static and has no BuildContext,
    // so it reaches this cubit through this reference.
    activeInstance = this;
  }

  /// The cubit instance wired into the widget tree (Home badge + list).
  static NotificationsCubit? activeInstance;

  static NotificationsCubit get(BuildContext context) =>
      BlocProvider.of<NotificationsCubit>(context);

  @override
  Future<void> close() {
    if (activeInstance == this) activeInstance = null;
    return super.close();
  }

  /// The notifications endpoint requires a `type` filter. The server-side
  /// tab switcher was removed in favour of the client-side read-status
  /// filter, so the app always fetches the general bucket.
  static const String defaultType = 'general';

  /// Client-side read-status filter applied on top of the loaded pages.
  /// 'all' | 'read' | 'unread'
  String readFilter = 'all';

  void setReadFilter(String value) {
    readFilter = value;
    emit(NotificationsButtonsToggleState());
  }

  List<Notifications> get filteredNotifications {
    switch (readFilter) {
      case 'read':
        return notificationsList
            .where((n) => n.isRead == true)
            .toList();
      case 'unread':
        return notificationsList
            .where((n) => n.isRead != true)
            .toList();
      default:
        return notificationsList;
    }
  }

  final NotificationsRepos notificationsRepos;
  NotificationsModel? notificationsModel;

  List<Notifications> notificationsList = [];

  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool get hasMore => currentPage < lastPage;

  /// Unread badge count (server value, adjusted optimistically).
  int unreadCount = 0;

  /// True when an FCM arrived but the server list hasn't been refetched yet.
  bool hasPendingUpdate = false;

  /// Last time page 1 was fetched successfully.
  DateTime? lastFetchAt;

  bool _isSilentSyncing = false;

  /// Should the notifications screen fetch when it opens?
  /// Covers: empty list, FCM pending update, or stale data older than 30s.
  bool get shouldRefreshOnOpen =>
      notificationsList.isEmpty ||
      hasPendingUpdate ||
      lastFetchAt == null ||
      DateTime.now().difference(lastFetchAt!) > const Duration(seconds: 30);

  /// Mark that a new notification arrived (e.g. user tapped the system
  /// notification) so the screen refetches on open and the badge syncs.
  /// Does NOT bump the badge — the server count will be authoritative.
  void markPendingUpdate() {
    hasPendingUpdate = true;
  }

  /// Called when an FCM arrives while the app is in the foreground.
  /// Bumps the badge instantly so the Home icon shows the new count,
  /// then silently refetches the list so the new item appears too.
  void onNewNotificationArrived() {
    if (GuestGuard.isGuest || isClosed) return;
    hasPendingUpdate = true;
    unreadCount++;
    emit(NewNotificationArrived());
    silentRefresh();
  }

  /// Refetch page 1 without showing the loading state, keeping whatever
  /// the user sees on screen while the new notification fades in.
  Future<void> silentRefresh() async {
    if (_isSilentSyncing ||
        isClosed ||
        GuestGuard.isGuest) {
      return;
    }
    _isSilentSyncing = true;
    try {
      final result = await notificationsRepos.getNotificationsData(
        type: defaultType,
        page: 1,
      );
      if (isClosed) return;
      result.fold((failure) {
        debugPrint(
            'NotificationsCubit silentRefresh failed: ${failure.errMessage}');
        // Keep the optimistic unreadCount — it will sync on next refresh.
      }, (data) {
        if (data.status == true) {
          notificationsModel = data;
          final items = data.data?.notifications ?? [];
          final pagination = data.data?.pagination;
          if (pagination != null) {
            currentPage = pagination.currentPage ?? 1;
            lastPage = pagination.lastPage ?? 1;
          } else {
            currentPage = 1;
            lastPage = 1;
          }
          unreadCount = data.data?.unreadCount ??
              items.where((n) => n.isRead != true).length;
          notificationsList = [...items];
          lastFetchAt = DateTime.now();
          hasPendingUpdate = false;
          emit(GetNotificationsDataSuccess(data));
        }
      });
    } finally {
      _isSilentSyncing = false;
    }
  }

  Future<void> getNotificationsData({
    String? type,
    bool loadMore = false,
  }) async {
    final t = type ?? defaultType;
    if (loadMore) {
      if (isLoadingMore || !hasMore) return;
      isLoadingMore = true;
      emit(GetNotificationsDataPaginating());
    } else {
      currentPage = 1;
      lastPage = 1;
      emit(GetNotificationsDataLoading());
    }
    final page = loadMore ? currentPage + 1 : 1;
    var result = await notificationsRepos.getNotificationsData(
      type: t,
      page: page,
    );
    return result.fold((failure) {
      debugPrint('NotificationsCubit get failed: ${failure.errMessage}');
      isLoadingMore = false;
      if (loadMore) {
        emit(GetNotificationsDataPaginationError(failure.errMessage));
      } else {
        emit(GetNotificationsDataError(failure.errMessage));
      }
    }, (data) {
      if(data.status==true){
        notificationsModel = data;
        final items = data.data?.notifications ?? [];
        final pagination = data.data?.pagination;
        if (pagination != null) {
          currentPage = pagination.currentPage ?? page;
          lastPage = pagination.lastPage ?? page;
        } else {
          currentPage = page;
          lastPage = page;
        }
        unreadCount = data.data?.unreadCount ??
            items.where((n) => n.isRead != true).length;
        if (loadMore) {
          notificationsList = [...notificationsList, ...items];
        } else {
          notificationsList = [...items];
          lastFetchAt = DateTime.now();
          hasPendingUpdate = false;
        }
        isLoadingMore = false;
        emit(GetNotificationsDataSuccess(data));
      }
      else{
        isLoadingMore = false;
        final msg = data.message ?? 'Something went wrong';
        if (loadMore) {
          emit(GetNotificationsDataPaginationError(msg));
        } else {
          emit(GetNotificationsDataError(msg));
        }
      }
    });
  }

  Future<void> refresh() =>
      getNotificationsData(type: defaultType);

  /// Mark one as read (optimistic, badge decreases instantly).
  Future<void> markAsRead(String? notificationId) async {
    if (notificationId == null) return;
    final index =
        notificationsList.indexWhere((n) => n.id == notificationId);
    final wasUnread = index != -1 &&
        notificationsList[index].isRead != true;
    if (index != -1) {
      notificationsList[index].isRead = true;
      if (wasUnread && unreadCount > 0) unreadCount--;
      emit(NotificationMarkedRead(notificationId));
    }
    var result = await notificationsRepos
        .markNotificationRead(notificationId: notificationId);
    return result.fold((failure) {
      debugPrint('NotificationsCubit markAsRead failed: ${failure.errMessage}');
      // Revert on failure.
      if (index != -1 && wasUnread) {
        notificationsList[index].isRead = false;
        unreadCount++;
        emit(NotificationMarkedRead(notificationId));
      }
    }, (_) {});
  }

  Future<void> markAllAsRead() async {
    final backup = notificationsList
        .map((n) => n.isRead)
        .toList();
    for (final n in notificationsList) {
      n.isRead = true;
    }
    unreadCount = 0;
    emit(AllNotificationsMarkedRead());
    var result =
        await notificationsRepos.markAllNotificationsRead();
    return result.fold((failure) {
      debugPrint('NotificationsCubit markAllAsRead failed: ${failure.errMessage}');
      for (int i = 0; i < notificationsList.length; i++) {
        notificationsList[i].isRead = backup[i];
      }
      unreadCount =
          notificationsList.where((n) => n.isRead != true).length;
      emit(AllNotificationsMarkedRead());
    }, (_) {});
  }

  Future<void> deleteNotification(String? notificationId) async {
    if (notificationId == null) return;
    final index =
        notificationsList.indexWhere((n) => n.id == notificationId);
    Notifications? removed;
    if (index != -1) {
      removed = notificationsList.removeAt(index);
      if (removed.isRead != true && unreadCount > 0) unreadCount--;
      emit(NotificationDeleted(notificationId));
    }
    var result = await notificationsRepos
        .deleteNotification(notificationId: notificationId);
    return result.fold((failure) {
      debugPrint('NotificationsCubit delete failed: ${failure.errMessage}');
      if (removed != null && index != -1) {
        notificationsList.insert(index, removed);
        if (removed.isRead != true) unreadCount++;
        emit(NotificationDeleted(notificationId));
      }
    }, (_) {});
  }

  Future<void> deleteAllNotifications() async {
    final backup = [...notificationsList];
    final backupUnread = unreadCount;
    notificationsList.clear();
    unreadCount = 0;
    emit(AllNotificationsDeleted());
    var result =
        await notificationsRepos.deleteAllNotifications();
    return result.fold((failure) {
      debugPrint('NotificationsCubit deleteAll failed: ${failure.errMessage}');
      notificationsList = backup;
      unreadCount = backupUnread;
      emit(AllNotificationsDeleted());
    }, (_) {});
  }
}
