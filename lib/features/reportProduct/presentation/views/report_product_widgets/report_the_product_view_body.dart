import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_loading.dart';
import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/states.dart';
import 'package:by3ly/features/reportProduct/presentation/views/report_product_widgets/reason_item_widget.dart';
 import 'package:by3ly/lang/locale_keys.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/report_product_cubit.dart';
import '../../view_model/report_product_states.dart';

class ReportTheProductViewBody extends StatelessWidget {
  const ReportTheProductViewBody({super.key, this.sellerId, this.productId});
  final int? sellerId;
  final int? productId;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportProductCubit , ReportProductStates>(
      listener:(context , state ){
        if(state is AddComplaintSuccess){
          CherryToast.success(
            title:  Text(state.addComplaintModel.message!,
                style: const TextStyle(color: AppColors.mainColor)),
          ).show(context);
          ReportProductCubit.get(context).resetValues();
        }
      },
      builder: (context , state ){
        var reportProductCubit = ReportProductCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text(context.tr(LocaleKeys.reasonForReport),
                style: AppStyles.textStyle16W600Black.copyWith(
                    fontSize: 20
                ),),
              const CustomSizedBox(height: 10,),
                Text(context.tr(LocaleKeys.tellUsWhatHappened),
                style: AppStyles.textStyle12W600Gary,),
              const CustomSizedBox(height: 20,),
              state is GetAllCategoriesLoading ? const CustomLoading() :
              ListView.separated(
                shrinkWrap: true,
                physics:const NeverScrollableScrollPhysics(),
                itemBuilder: (context , index ){
                  return ReasonItemWidget(
                    title: reportProductCubit.allComplaintsTypesList[index].text!,
                    index: reportProductCubit.allComplaintsTypesList[index].id!,
                  );
                },
                separatorBuilder: (context , index ){
                  return const CustomSizedBox(height: 10,);
                },
                itemCount: reportProductCubit.allComplaintsTypesList.length,
              ),
              const CustomSizedBox(height: 20,),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                   Text(context.tr(LocaleKeys.notes),
                   style: AppStyles.textStyle16W600Black,),
                 const CustomSizedBox(height: 20,),
                 CustomTextFormField(
                   keyboardType: TextInputType.text,
                   hintText: context.tr(LocaleKeys.writeReasonForReport),
                   maxLines: 5,
                   controller: reportProductCubit.messageCon,
                 ),
                 const CustomSizedBox(height: 40,),
                 ConditionalBuilder(
                   condition: state is ! AddComplaintLoading,
                   fallback: (context)=>const CustomLoading(),
                   builder: (context){
                     return CustomButton(
                       btnText:  Text(context.tr(LocaleKeys.send),
                         style: const TextStyle(
                           fontSize: 16,
                           fontWeight: FontWeight.w600,
                           color: AppColors.whiteColor,
                         ),),
                       onPressed: (){
                         reportProductCubit.addComplaint(
                             productId: productId,
                             sellerId: sellerId,
                         message: reportProductCubit.messageCon.text,
                           complaintId: reportProductCubit.reasonIndex,
                         );
                       },
                     );
                   },

                 ),
               ],
             ),
            ],
          ),
        );
      },

    );
  }
}
