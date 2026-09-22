import 'package:by3ly/features/notifications/presentation/view_model/notifications_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/notifications_cubit.dart';
import 'notifications_buttons_types_item.dart';

class NotificationsButtonsTypes extends StatelessWidget {
  const NotificationsButtonsTypes({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<NotificationsCubit , NotificationsStates>(
      builder: (context , state ){
        var notificationsCubit = NotificationsCubit.get(context);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
                itemBuilder: (context , index ){
                  return  NotificationsButtonsTypesItem(index : index);
                },
                separatorBuilder: (context , index ){
                return const SizedBox(width: 10,);
                },
                itemCount: notificationsCubit.buttonMap.length,
            ),
          ),
        );
      },

    );
  }
}
