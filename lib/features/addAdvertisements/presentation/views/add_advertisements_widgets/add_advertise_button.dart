import 'package:easy_localization/easy_localization.dart';

import '../../../../../main_importants.dart';
import '../../../../privacy/presentation/view_model/privacy_cubit.dart';
import '../../view_model/add_advertisements_cubit.dart';
import '../../view_model/add_advertisements_states.dart';

class AddAdvertiseButton extends StatelessWidget {
  const AddAdvertiseButton({super.key, required this.categoryId, required this.subCategoryId});
  final int categoryId;
  final int subCategoryId;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddAdvertisementsCubit , AddAdvertisementsStates>(
      builder: (context,state){
        var addAdvertisementsCubit = AddAdvertisementsCubit.get(context);
        return ConditionalBuilder(
          condition: state is ! AddProductAdvertisementsLoadingState,
          fallback: (context){
            return const CustomLoading();
          },
          builder:  (context){
            return CustomButton(
              btnText: Text(LocaleKeys.next.tr(),
                style: AppStyles.textStyle16W600Black.copyWith(
                  color: AppColors.whiteColor,
                ),),
              onPressed: (){
                addAdvertisementsCubit.addProductAdvertisement(
                  communication:  PrivacyCubit.get(context).wayIndex,
                  negotiable:   addAdvertisementsCubit.isChecked==true ? 1 : 0 ,
                  phone:addAdvertisementsCubit.advertisePhoneCon.text,
                  nameAr: addAdvertisementsCubit.advertiseNameCon.text,
                  descAr: addAdvertisementsCubit.advertiseDesCon.text,
                  price: addAdvertisementsCubit.advertisePriceCon.text,
                  categoryId: categoryId,
                  subCategoryId: subCategoryId,
                  markaId: addAdvertisementsCubit.selectedCarMarkaId ?? 0,
                  modelId:  addAdvertisementsCubit.selectedCarModelId ?? 0,
                  typeId:  addAdvertisementsCubit.selectedCarTypeId ?? 0,
                  lat: 22.2222222222,
                  long: 33.33333333,
                  images: addAdvertisementsCubit.images,
                );
              },
            );
          },

        );
      },
    );
  }
}
