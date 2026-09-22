import 'package:by3ly/features/notifications/data/models/notifications_model.dart';
import 'package:by3ly/features/notifications/data/repos/notifications_repos.dart';
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

  NotificationsRepos? notificationsRepos;
  NotificationsModel? notificationsModel;


  Future<void> getNotificationsData({required String type}) async {
    emit(GetNotificationsDataLoading());
    var result = await notificationsRepos!.getNotificationsData(type: type);
    return result.fold((failure) {
      emit(GetNotificationsDataError(failure.errMessage));
    }, (data) {
      if(data.status==true){
        notificationsModel = data;
        emit(GetNotificationsDataSuccess(data));
      }
      else{
        emit(GetNotificationsDataError(data.message.toString()));
      }
    });
  }


}