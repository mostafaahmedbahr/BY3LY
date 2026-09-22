import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../view_model/add_advertisements_cubit.dart';
import '../../view_model/add_advertisements_states.dart';
import 'add_car_data_widgets/select_marka_model_type.dart';

class ProductDataForm extends StatelessWidget {
  const ProductDataForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddAdvertisementsCubit , AddAdvertisementsStates>(
     builder: (context,state){
       var addAdvertisementsCubit = AddAdvertisementsCubit.get(context);
       return  Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           /// اسم الاعلان
           Text(
             LocaleKeys.advertiseName.tr(),
             style: AppStyles.textStyle16W500Black,
           ),
           const CustomSizedBox(height: 10,),
           CustomTextFormField(
             controller: addAdvertisementsCubit.advertiseNameCon,
             hintText: LocaleKeys.productName.tr(),
             keyboardType: TextInputType.name,
           ),
           const CustomSizedBox(height: 10,),
           const SelectMarkaModelType(),
           const CustomSizedBox(height: 10,),

           /// الوصف
           Text(
             LocaleKeys.advertiseDes.tr(),
             style: AppStyles.textStyle16W500Black,
           ),
           const CustomSizedBox(height: 10,),
           CustomTextFormField(
             controller: addAdvertisementsCubit.advertiseDesCon,
             hintText: LocaleKeys.advertiseDes.tr(),
             keyboardType: TextInputType.name,
           ),
           const CustomSizedBox(height: 10,),

           /// السعر
           Text(
             LocaleKeys.price.tr(),
             style: AppStyles.textStyle16W500Black,
           ),
           const CustomSizedBox(height: 10,),
           CustomTextFormField(
             controller: addAdvertisementsCubit.advertisePriceCon,
             hintText: LocaleKeys.typeProductPrice.tr(),
             keyboardType: TextInputType.number,
           ),
           const CustomSizedBox(height: 10,),

           /// رقم الهاتف
           Text(
             LocaleKeys.phoneNumber.tr(),
             style: AppStyles.textStyle16W500Black,
           ),
           const CustomSizedBox(height: 10,),
           CustomTextFormField(
             controller: addAdvertisementsCubit.advertisePhoneCon,
             hintText: LocaleKeys.typeYourPhoneNumber.tr(),
             keyboardType: TextInputType.number,
           ),
           const CustomSizedBox(height: 10,),
         ],
       );
     },
    );
  }
}
