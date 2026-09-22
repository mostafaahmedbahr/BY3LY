import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../privacy/presentation/view_model/privacy_cubit.dart';
import '../../../../privacy/presentation/view_model/privacy_states.dart';
import '../../view_model/add_advertisements_cubit.dart';
import '../../view_model/add_advertisements_states.dart';

class CommunicationMethod extends StatelessWidget {
  const CommunicationMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddAdvertisementsCubit , AddAdvertisementsStates>(
        builder: (context,state){
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///طريقة التواصل
          Text(LocaleKeys.connectionWy.tr(),
            style: AppStyles.textStyle16W600Black,),
          BlocBuilder<PrivacyCubit , PrivacyStates>(
            builder: (context , state ){
              var privacyCubit = PrivacyCubit.get(context);
              return Padding(
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
                        child:   Center(child: Text(LocaleKeys.by3lyChat.tr(),
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
                        child:   Center(child: Text(LocaleKeys.phone.tr(),
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
                        child:   Center(child: Text(LocaleKeys.both.tr(),
                          style: TextStyle(
                            color: privacyCubit.wayIndex==3  ?
                            AppColors.whiteColor : AppColors.greyColor,
                          ),)),
                      ),
                    ),
                  ],
                ),
              );
            },

          ),
          const SizedBox(height: 10,),
        ],
      );
    });
  }
}
