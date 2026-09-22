import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/models/notifications_model.dart';

class NotificationsListItem extends StatelessWidget {
  const NotificationsListItem({super.key, required this.index, required this.notification});
 final int index;
 final Notifications notification;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
        index % 2 == 0 ?
        const Color.fromRGBO(248, 248, 248, 1) :
        const Color.fromRGBO(250, 176, 67, 0.1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(imageUrl: notification.userImage.toString(),
                height:35 ,
                width: 35 ,
              ),
              const SizedBox(width:5,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text("${notification.userName}",
                    style: AppStyles.textStyle10W600Black,),
                    const SizedBox(height:5,),
                    Text("${notification.type}",
                      style: AppStyles.textStyle12W600Gary.copyWith(
                        color:  index % 2 == 0 ?
                        AppColors.mainColor : AppColors.yellowColor
                      ),),
                      Text("( ${notification.message} )",
                      style: AppStyles.textStyle10W600Black,
                    maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
               Row(
                children: [
                     Text(notification.createdAt.toString(),
                    style: AppStyles.textStyle10W600Black,),
                  const  SizedBox(width:5,),
                  CircleAvatar(
                    radius: 5,
                    backgroundColor:
                    index % 2 == 0 ?
                    AppColors.mainColor : AppColors.yellowColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
