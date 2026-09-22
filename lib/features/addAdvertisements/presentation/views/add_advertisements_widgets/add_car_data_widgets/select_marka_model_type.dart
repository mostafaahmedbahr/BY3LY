import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../data/models/get_car_marka_model.dart';
import '../../../../data/models/get_car_models_model.dart';
import '../../../../data/models/get_car_types_model.dart';
import '../../../view_model/add_advertisements_cubit.dart';
import '../../../view_model/add_advertisements_states.dart';

class SelectMarkaModelType extends StatelessWidget {
  const SelectMarkaModelType({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddAdvertisementsCubit , AddAdvertisementsStates>(
     builder: (context,state){
       var addAdvertisementsCubit = AddAdvertisementsCubit.get(context);

       return Column(
         crossAxisAlignment:  CrossAxisAlignment.start,
         children: [
           /// الماركة
           const Text(
             "اختر الماركة",
             style: AppStyles.textStyle16W500Black,
           ),
           const CustomSizedBox(height: 10,),
           CustomDropdown<Marka>(
             value: addAdvertisementsCubit.selectedCarMarka,
             hint: 'اختر الماركة',
             items: addAdvertisementsCubit.allCarsMarkaList,
             onChanged: (Marka? newMarka) {
               addAdvertisementsCubit.selectCarMarkaMethod(newMarka!);
             },
             itemDisplayBuilder: (Marka marka) {
               return marka.name ?? 'Unknown';  // Custom display for Marka (display name)
             },
           ),
           const CustomSizedBox(height: 10,),
           /// المودل
           const Text(
             "اختر المودل",
             style: AppStyles.textStyle16W500Black,
           ),
           const CustomSizedBox(height: 10,),
           CustomDropdown<Models>(
             value: addAdvertisementsCubit.selectedCarModel,
             hint: 'اختر المودل',
             items: addAdvertisementsCubit.allCarsModelsList,
             onChanged: (Models? newModel) {
               addAdvertisementsCubit.selectCarModelMethod(newModel!);
             },
             itemDisplayBuilder: (Models model) {
               return model.name ?? 'Unknown';  // Custom display for Marka (display name)
             },
           ),
           const CustomSizedBox(height: 10,),
           /// النوع
           const Text(
             "اختر النوع",
             style: AppStyles.textStyle16W500Black,
           ),
           const CustomSizedBox(height: 10,),
           CustomDropdown<Typies>(
             value: addAdvertisementsCubit.selectedCarType,
             hint: 'اختر النوع',
             items: addAdvertisementsCubit.allCarsTypesList,
             onChanged: (Typies? newType) {
               addAdvertisementsCubit.selectCarTypesMethod(newType!);
             },
             itemDisplayBuilder: (Typies type) {
               return type.name ?? 'Unknown';  // Custom display for Marka (display name)
             },
           ),
         ],
       );
     },
    );
  }
}
