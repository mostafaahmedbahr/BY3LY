import '../../data/models/notifications_model.dart';

abstract class NotificationsStates{}

class NotificationsInitState extends NotificationsStates{
  @override
  String toString() => 'NotificationsInitState';
}

class NotificationsButtonsToggleState extends NotificationsStates{
  @override
  String toString() => 'NotificationsButtonsToggleState';
}


class GetNotificationsDataLoading extends NotificationsStates {
  @override
  String toString() => 'GetNotificationsDataLoading';
}

class GetNotificationsDataSuccess extends NotificationsStates {
  final NotificationsModel notificationsModel;
  GetNotificationsDataSuccess(this.notificationsModel);

  @override
  String toString() => 'GetNotificationsDataSuccess';
}

class GetNotificationsDataError extends NotificationsStates {
  final String message;
  GetNotificationsDataError(this.message);

  @override
  String toString() => 'GetNotificationsDataError(message: $message)';
}

class GetNotificationsDataPaginating extends NotificationsStates {
  @override
  String toString() => 'GetNotificationsDataPaginating';
}

class GetNotificationsDataPaginationError extends NotificationsStates {
  final String message;
  GetNotificationsDataPaginationError(this.message);

  @override
  String toString() =>
      'GetNotificationsDataPaginationError(message: $message)';
}

class NotificationMarkedRead extends NotificationsStates {
  final String notificationId;
  NotificationMarkedRead(this.notificationId);

  @override
  String toString() =>
      'NotificationMarkedRead(id: $notificationId)';
}

class AllNotificationsMarkedRead extends NotificationsStates {
  @override
  String toString() => 'AllNotificationsMarkedRead';
}

class NotificationDeleted extends NotificationsStates {
  final String notificationId;
  NotificationDeleted(this.notificationId);

  @override
  String toString() => 'NotificationDeleted(id: $notificationId)';
}

class AllNotificationsDeleted extends NotificationsStates {
  @override
  String toString() => 'AllNotificationsDeleted';
}
