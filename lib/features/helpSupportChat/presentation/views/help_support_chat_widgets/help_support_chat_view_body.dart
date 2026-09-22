import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/helpSupportChat/presentation/view_model/help_support_chat_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../lang/locale_keys.dart';
import '../../view_model/help_support_chat_states.dart';

class HelpSupportChatViewBody extends StatelessWidget {
  const HelpSupportChatViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HelpSupportChatCubit , HelpSupportChatStates>(
     listener:  (context , state ){},
      builder:  (context , state ){
       var helpSupportChatCubit = HelpSupportChatCubit.get(context);

       return  Column(
         children: [
           Expanded(
             child: ListView.builder(
               reverse: true,
               controller: helpSupportChatCubit.scrollController,
               itemCount: helpSupportChatCubit.messages.length,
               itemBuilder: (context, index) {
                 return ListTile(
                   title: Text(helpSupportChatCubit.messages[index]),
                 );
               },
             ),
           ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
               children: [
                 Expanded(
                   child: CustomTextFormField(
                     controller: helpSupportChatCubit.controller,
                     hintText: context.tr(LocaleKeys.writeYourProblemHere),
                     prefixIcon: InkWell(
                       onTap: (){
                         helpSupportChatCubit.sendMessage();

                       },
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: SvgPicture.asset(AppImages.send),
                       ),
                     ),
                     icon: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: SvgPicture.asset(AppImages.camera3),
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ],
       );
      },
    );
  }
}
