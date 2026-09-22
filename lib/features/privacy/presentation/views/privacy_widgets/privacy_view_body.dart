import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/features/privacy/presentation/view_model/privacy_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/privacy_cubit.dart';

class PrivacyViewBody extends StatelessWidget {
  const PrivacyViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return   BlocConsumer<PrivacyCubit , PrivacyStates>(
       listener: (context , state ){},
      builder:   (context , state ){
         var privacyCubit = PrivacyCubit.get(context);
         return  Padding(
           padding: const EdgeInsets.all(20.0),
           child: ListView(
             children: [
                 Text(context.tr(LocaleKeys.connectionWy),
                 style: AppStyles.textStyle16W600Black,),
               Padding(
                 padding: const EdgeInsets.symmetric(vertical: 10),
                 child: Row(
                   children: [
                     InkWell(
                       onTap: (){
                         privacyCubit.changeConnectionWay(privacyCubit.wayIndex=1);
                       },
                       child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 10),
                         height: 30,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color:privacyCubit.wayIndex==1  ?
                             AppColors.mainColor : AppColors.whiteColor,
                             border: Border.all(
                               color:privacyCubit.wayIndex==1  ?
                               AppColors.mainColor : const Color(0xffB6B6B6),
                             )
                         ),
                         child:   Center(child: Text(context.tr(LocaleKeys.by3lyChat),
                           style: TextStyle(
                             color: privacyCubit.wayIndex==1  ?
                             AppColors.whiteColor : AppColors.greyColor,
                           ),)),
                       ),
                     ),
                     const SizedBox(width: 10,),
                     InkWell(
                       onTap: (){
                         privacyCubit.changeConnectionWay(privacyCubit.wayIndex=2);
                       },
                       child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 10),
                         height: 30,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color:privacyCubit.wayIndex==2  ?
                             AppColors.mainColor : AppColors.whiteColor,
                             border: Border.all(
                               color:privacyCubit.wayIndex==2  ?
                               AppColors.mainColor : const Color(0xffB6B6B6),
                             )
                         ),
                         child:   Center(child: Text(context.tr(LocaleKeys.phone2),
                           style: TextStyle(
                             color: privacyCubit.wayIndex==2  ?
                             AppColors.whiteColor : AppColors.greyColor,
                           ),)),
                       ),
                     ),
                     const SizedBox(width: 10,),
                     InkWell(
                       onTap: (){
                         privacyCubit.changeConnectionWay(privacyCubit.wayIndex=3);
                       },
                       child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 10),
                         height: 30,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color: privacyCubit.wayIndex==3  ?
                             AppColors.mainColor : AppColors.whiteColor,
                             border: Border.all(
                               color:privacyCubit.wayIndex==3  ?
                               AppColors.mainColor : const Color(0xffB6B6B6),
                             )
                         ),
                         child:   Center(child: Text(context.tr(LocaleKeys.both),
                           style: TextStyle(
                             color: privacyCubit.wayIndex==3  ?
                             AppColors.whiteColor : AppColors.greyColor,
                           ),)),
                       ),
                     ),
                   ],
                 ),
               ),
               const SizedBox(height: 10,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                    Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                         Text(context.tr(LocaleKeys.changePhoneNumber),
                         style: AppStyles.textStyle16W600Black,),
                       Text(privacyCubit.phoneNumberCon.text)
                     ],
                   ),
                   IconButton(
                     onPressed: (){
                       showModalBottomSheet(
                         backgroundColor: AppColors.whiteColor,
                         context: context,
                         builder: (BuildContext context) {
                           return Padding(
                             padding:   EdgeInsets.only(
                               left: 20,
                               right: 20,
                               top: 20,
                               bottom: MediaQuery.of(context).viewInsets.bottom,
                             ),
                             child: Column(
                               mainAxisSize: MainAxisSize.min,
                               children: <Widget>[
                                 CustomTextFormField(
                                   onChanged: (value){
                                     privacyCubit.changePhoneNumber(value);
                                   },
                                   controller: privacyCubit.phoneNumberCon,
                                   keyboardType: TextInputType.number,
                                   hintText: context.tr(LocaleKeys.enterNewPhoneNumber),
                                 ),
                                 const SizedBox(height: 20),
                                 Expanded(
                                   child: ListView.builder(
                                     shrinkWrap: true,
                                     itemCount: 3,
                                     itemBuilder: (context, index) {
                                       return ListTile(
                                         onTap: (){
                                           privacyCubit.changePhoneNumber(privacyCubit.numbers[index]);
                                          // Navigator.pop(context);
                                         },
                                         title: Text(privacyCubit.numbers[index]),
                                       );
                                     },
                                   ),
                                 ),
                                 const SizedBox(height: 20),
                                 CustomButton(
                                   btnText: Text(context.tr(LocaleKeys.save),
                                     style: AppStyles.textStyle16W600Black.copyWith(
                                       color: AppColors.whiteColor,
                                     ),),
                                   onPressed: (){
                                     privacyCubit.changePhoneNumber(privacyCubit.phoneNumberCon.text);
                                     Navigator.pop(context);
                                   },
                                 ),
                                 const SizedBox(height: 20),
                               ],
                             ),
                           );
                         },
                       );
                     },
                     icon: const Icon(Icons.change_circle_outlined),
                   ),
                 ],
               ),
               const SizedBox(height: 40,),
               CustomButton(
                   btnText: Text(context.tr(LocaleKeys.save),
                   style: AppStyles.textStyle16W600Black.copyWith(
                     color: AppColors.whiteColor,
                   ),),
                   onPressed: (){
                     Navigator.pop(context);
                   },
               ),
             ],
           ),
         );
      },
    );
  }
}
