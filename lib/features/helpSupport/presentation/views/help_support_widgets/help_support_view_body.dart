 import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../helpSupportChat/presentation/views/help_support_chat_view.dart';
 import '../../../../reportProduct/presentation/views/report_the_product_view.dart';
import '../../view-model/help_support_cubit.dart';
import '../../view-model/help_support_states.dart';
import 'common_questions_widget.dart';
import 'help_support_list_item_widget.dart';

class HelpSupportViewBody extends StatelessWidget {
  const HelpSupportViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelpSupportCubit , HelpSupportStates>(
      builder: (  context,   state) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              HelpSupportListItemWidget(
                onTap: (){
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: const HelpSupportChatView(),
                    ),
                  );
                },
                title: context.tr(LocaleKeys.chat),
                subTitle: context.tr(LocaleKeys.speakWithUsDirectly),
              ),
              HelpSupportListItemWidget(
                onTap: (){
                  HelpSupportCubit.get(context).sendEmail();
                },
                title: context.tr(LocaleKeys.email),
                subTitle: 'bi3lyapp@example.com',
              ),
              HelpSupportListItemWidget(
                onTap: (){
                  HelpSupportCubit.get(context).makePhoneCall();
                },
                title: context.tr(LocaleKeys.callUs),
                subTitle: '01110690299',
              ),
              HelpSupportListItemWidget(
                onTap: (){
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const ReportTheProductView(),
                    ),
                  );
                },
                title: context.tr(LocaleKeys.report),
                subTitle: context.tr(LocaleKeys.reportProduct),
              ),
              HelpSupportListItemWidget(
                onTap: (){
                  // Navigator.push(
                  //   context,
                  //   PageTransition(
                  //     type: PageTransitionType.rightToLeft,
                  //     child: const ReportTheProductView(),
                  //   ),
                  // );
                },
                title: context.tr(LocaleKeys.report),
                subTitle: context.tr(LocaleKeys.reportSeller),
              ),
              const SizedBox(height: 20,),
              const CommonQuestionsWidget(),
            ],
          ),
        );
      },

    );
  }
}
