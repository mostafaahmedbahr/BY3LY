 import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';

import '../app_colors/app_colors.dart';


class Toast
 {

   static showSuccessToast({
     required String msg,
     required BuildContext context,
     Duration? duration,
   }) =>
       CherryToast.success(
         toastDuration : duration??const Duration(milliseconds: 3000),
         width: MediaQuery.of(context).size.width*0.8,
         title:  Text(msg, style: const TextStyle(color: AppColors.blackColor)),
       ).show(context);


   static showErrorToast({
     required String msg,
     required BuildContext context,
   }) =>
       CherryToast.error(
         width: MediaQuery.of(context).size.width*0.8,
         title:  Text(msg, style: const TextStyle(color: AppColors.blackColor)),
       ).show(context);
 }

