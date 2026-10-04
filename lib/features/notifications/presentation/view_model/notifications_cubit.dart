
import 'package:by3ly/features/notifications/data/models/notifications_model.dart';
import 'package:by3ly/features/notifications/data/repos/notifications_repos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifications_states.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  NotificationsCubit(this.notificationsRepos) : super(NotificationsInitState());

  static NotificationsCubit get(context) => BlocProvider.of(context);

  int buttonIndex = 1;

  buttonsToggle(newIndexValue){
    buttonIndex = newIndexValue;
    emit(NotificationsButtonsToggleState());
  }

  Map<String, String> buttonMap = {
    "الكل": "general",
    "الغير مقروء": "unread",
    "طلبات الشراء": "purchaseRequests",
    "الرسائل العاديه": "regularMessages",
  };

  String get currentType =>
      buttonMap.values.elementAt(buttonIndex.clamp(0, buttonMap.length - 1));

  NotificationsRepos? notificationsRepos;
  NotificationsModel? notificationsModel;

  List<Notifications> notificationsList = [];

  int currentPage = 1;
  int lastPage = 1;
  bool isLoadingMore = false;
  bool get hasMore => currentPage < lastPage;

  /// Unread badge count (server value, adjusted optimistically).
  int unreadCount = 0;

  Future<void> getNotificationsData({
    String? type,
    bool loadMore = false,
  }) async {
    final t = type ?? currentType;
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
    var result = await notificationsRepos!.getNotificationsData(
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
      getNotificationsData(type: currentType);

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
    var result = await notificationsRepos!
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
        await notificationsRepos!.markAllNotificationsRead();
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
    var result = await notificationsRepos!
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
        await notificationsRepos!.deleteAllNotifications();
    return result.fold((failure) {
      debugPrint('NotificationsCubit deleteAll failed: ${failure.errMessage}');
      notificationsList = backup;
      unreadCount = backupUnread;
      emit(AllNotificationsDeleted());
    }, (_) {});
  }
}
