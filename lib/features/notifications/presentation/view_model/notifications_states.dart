import '../../data/models/notifications_model.dart';

abstract class NotificationsStates{}

class NotificationsInitState extends NotificationsStates{}

class NotificationsButtonsToggleState extends NotificationsStates{}


class GetNotificationsDataLoading extends NotificationsStates {}

class GetNotificationsDataSuccess extends NotificationsStates {
  final NotificationsModel notificationsModel;
  GetNotificationsDataSuccess(this.notificationsModel);
}

class GetNotificationsDataError extends NotificationsStates {
  final String message;
  GetNotificationsDataError(this.message);
}
