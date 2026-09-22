import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../view_model/notifications_cubit.dart';
import '../../view_model/notifications_states.dart';

class NotificationsButtonsTypesItem extends StatelessWidget {
  const NotificationsButtonsTypesItem({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit , NotificationsStates>(
        builder: (context , state ){
          var notificationsCubit = NotificationsCubit.get(context);
          String buttonLabel = notificationsCubit.buttonMap.keys.elementAt(index);
          String buttonKey = notificationsCubit.buttonMap[buttonLabel]!;
          return InkWell(
            onTap: (){
              notificationsCubit.buttonsToggle(notificationsCubit.buttonIndex=index+1);
              notificationsCubit.getNotificationsData(type: buttonKey);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:notificationsCubit.buttonIndex==index+1  ?
                  AppColors.mainColor : AppColors.whiteColor,
                  border: Border.all(
                    color:notificationsCubit.buttonIndex==index+1  ?
                    AppColors.mainColor : const Color(0xffB6B6B6),
                  )
              ),
              child:   Center(child: Text(buttonLabel,
                style: TextStyle(
                  color: notificationsCubit.buttonIndex==index+1  ?
                  AppColors.whiteColor : AppColors.greyColor,
                ),)),
            ),
          );
        },

    );
  }
}
