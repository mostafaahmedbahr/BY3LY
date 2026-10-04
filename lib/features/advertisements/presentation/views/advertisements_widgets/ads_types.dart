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
              height: 38,
              child: ListView.separated(
                  itemCount: advertisementsCubit.types.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context,index){
                    final selected =
                        advertisementsCubit.advertisementsTypeIndex == index;
                    final count =
                        advertisementsCubit.countForTab(index);
                    return InkWell(
                      onTap: (){
                        // Instant client-side filter (no refetch needed).
                        advertisementsCubit.changeAdvertisementsTypeIndexWay(
                            advertisementsCubit.advertisementsTypeIndex = index);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        height: 38,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: selected
                                ? AppColors.mainColor
                                : AppColors.whiteColor,
                            border: Border.all(
                              color: selected
                                  ? AppColors.mainColor
                                  : const Color(0xffE3E6E9),
                            ),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: AppColors.mainColor
                                          .withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              advertisementsCubit.types[index],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: selected
                                    ? AppColors.whiteColor
                                    : AppColors.greyColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : const Color(0xffF1F3F5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: selected
                                      ? AppColors.whiteColor
                                      : AppColors.mainColor,
                                ),
                              ),
                            ),
                          ],
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
