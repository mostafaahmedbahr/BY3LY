import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/shared_widgets/no_data_widget.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:by3ly/features/notifications/presentation/views/notifications_widgets/notifications_list_item.dart';
import 'package:flutter/cupertino.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
      NotificationsCubit.get(context).notificationsModel!
          .data!.notifications!.isEmpty ? const NoDataWidget(
          image: "assets/images/Validation.svg",
          text: "لا يوجد اشعارات من هذا النوع حاليا",
      ):
      ListView.separated(
          itemBuilder:  (context , index ){
            return NotificationsListItem(
              index: index,
              notification: NotificationsCubit.get(context).notificationsModel!
                .data!.notifications![index],);
          },
          separatorBuilder: (context , index ){
            return const CustomSizedBox(height: 20,);
          },
          itemCount: NotificationsCubit.get(context).notificationsModel!
              .data!.notifications!.length,
      ),
    );
  }
}
