import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_states.dart';
import 'package:by3ly/main_importants.dart';

import '../../view_model/advertisements_cubit.dart';

class AdsTypes extends StatelessWidget {
  const AdsTypes({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementsCubit , AdvertisementsStates>(
      builder: (context,state){
        var advertisementsCubit = AdvertisementsCubit.get(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("اعلاناتي",style: AppStyles.textStyle16W500Black.copyWith(
              fontSize: 24,
            ),),
            const SizedBox(height: 10,),
            SizedBox(
              height: 30,
              child: ListView.builder(
                  itemCount: advertisementsCubit.types.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    return   Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: (){
                          advertisementsCubit.changeAdvertisementsTypeIndexWay(advertisementsCubit.advertisementsTypeIndex=index);
                          advertisementsCubit.getAllMyAdsDataMethod(type: advertisementsCubit.advertisementsTypeIndex);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:advertisementsCubit.advertisementsTypeIndex==index  ?
                              AppColors.mainColor : AppColors.whiteColor,
                              border: Border.all(
                                color:advertisementsCubit.advertisementsTypeIndex==index   ?
                                AppColors.mainColor : const Color(0xffB6B6B6),
                              )
                          ),
                          child:   Center(
                              child: Text(advertisementsCubit.types[index],
                                style: TextStyle(
                                  color: advertisementsCubit.advertisementsTypeIndex==index   ?
                                  AppColors.whiteColor : AppColors.greyColor,
                                ),)),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        );
      },
    );
  }
}
