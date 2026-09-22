import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_nav/new_app_nav.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
 import 'package:by3ly/features/login/presentation/views/login_view.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../lang/locale_keys.dart';
import '../../view_model/delete_account_cubit.dart';
import '../../view_model/delete_account_states.dart';

class DeleteAccountViewBody extends StatelessWidget {
  const DeleteAccountViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr(LocaleKeys.notice),
          style: AppStyles.textStyle16W600Black.copyWith(
            color: AppColors.mainColor,
          ),),
          const CustomSizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(radius: 5,backgroundColor: Colors.black87,),
              const CustomSizedBox(width: 10,),
              Expanded(
                child: Text(context.tr(LocaleKeys.accountDeletionWarning),
                  style: AppStyles.textStyle16W600Black.copyWith(
                    fontWeight: FontWeight.w400
                  ),),
              ),
            ],
          ),
          const CustomSizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(radius: 5,backgroundColor: Colors.black87,),
              const CustomSizedBox(width: 10,),
              Expanded(
                child: Text(context.tr(LocaleKeys.accountRestorationInfo),
                  style: AppStyles.textStyle16W600Black.copyWith(
                      fontWeight: FontWeight.w400
                  ),),
              ),
            ],
          ),
          const CustomSizedBox(height: 40,),
          BlocConsumer<DeleteAccountCubit , DeleteAccountStates>(
            listener: (context ,state){
              if(state is DeleteAccountSuccess){
                NewAppNav.customNavigator(context: context,
                    screen: const LoginView(),
                finish: true,
                );
                CherryToast.success(
                  title:  Text(state.deleteAccountModel.message!,
                      style: const TextStyle(color: AppColors.mainColor)),
                ).show(context);
              }
             else if(state is DeleteAccountError){
                CherryToast.error(
                  title:  Text(state.message,
                      style: const TextStyle(color: AppColors.redColor)),
                ).show(context);
              }
            },
            builder:  (context ,state){
              return
                state is DeleteAccountLoading ? const CustomLoading():
                CustomButton(
                btnColor: AppColors.redColor,
                borderColor: AppColors.redColor,
                btnText: Text(context.tr(LocaleKeys.deleteNow),
                  style: AppStyles.textStyle16W600Black.copyWith(
                      color: Colors.white
                  ),),
                onPressed: (){
                 context.read<DeleteAccountCubit>().deleteAccount();
                },
              );
            },

          ),
        ],
      ),
    );
  }
}
