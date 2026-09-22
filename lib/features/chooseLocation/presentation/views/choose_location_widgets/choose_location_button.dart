import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../view_model/choose_location_cubit.dart';
import '../../view_model/choose_location_states.dart';

class ChooseLocationButton extends StatelessWidget {
  const ChooseLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseLocationCubit, ChooseLocationStates>(
     builder: (context,state){
       var chooseLocationCubit = ChooseLocationCubit.get(context);
       return Column(
         children: [
           chooseLocationCubit.selectedCity.isEmpty
               ? CustomButton(
             btnColor: const Color(0xffB6B6B6),
             borderColor: const Color(0xffB6B6B6),
             btnText: Text(
               context.tr(LocaleKeys.choose),
               style: AppStyles.textStyle16W600Black.copyWith(color: Colors.white),
             ),
             onPressed: () {
               CherryToast.info(
                 title:   Text(context.tr(LocaleKeys.selectGovernorate),
                     style: const TextStyle(color: Colors.black)),
               ).show(context);
             },
           )
               :
           state is AddLocationCitiesAndCentersLoading ? const CustomLoading():
           CustomButton(
             btnColor: AppColors.mainColor,
             btnText: Text(
               context.tr(LocaleKeys.choose),
               style: AppStyles.textStyle16W600Black.copyWith(color: Colors.white),
             ),
             onPressed: () {
               if (chooseLocationCubit.selectedCenter.isEmpty) {
                 CherryToast.info(
                   title:  Text(context.tr(LocaleKeys.chooseCenter),
                       style: const TextStyle(color: Colors.black)),
                 ).show(context);
               } else if (chooseLocationCubit.countryIsSelect && chooseLocationCubit.selectedCenter.isNotEmpty) {
                 chooseLocationCubit.addLocationCityAndCenter(
                   cityId: chooseLocationCubit.selectedCityId.toString(),
                   centerId: chooseLocationCubit.selectedCenterId.toString(),
                 );
               }
             },
           ),
         ],
       );
     },
    );
  }
}
