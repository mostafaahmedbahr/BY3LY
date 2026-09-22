import  'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

 import '../../../../../core/app_services/remote_services/service_locator.dart';
import '../../../data/repos/notifications_repos_imple.dart';
import '../../view_model/notifications_states.dart';
import 'notifications_buttons_types.dart';
import 'notifications_list.dart';

class NotificationsViewBody extends StatelessWidget {
  const NotificationsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return   BlocProvider(
      create: (context) => NotificationsCubit(getIt.get<NotificationsDataRepoImpl>())..getNotificationsData(type: "general"),
      child: BlocBuilder<NotificationsCubit , NotificationsStates>(
          builder: (context , state ){
            return  Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const NotificationsButtonsTypes(),
                  const SizedBox(height: 20,),
                   state is GetNotificationsDataLoading ? const Expanded(child: CustomLoading()):
                      state is GetNotificationsDataError ? const Text("Error"):
                  const NotificationsList() ,
                ],
              ),
            );
          }

      ),
    );
  }
}
