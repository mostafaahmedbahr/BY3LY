import 'package:by3ly/features/howToMakePurchase/data/repos/how_to_make_purchase_repos_imple.dart';
import 'package:by3ly/main_importants.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../view_model/how_to_make_purchase_cubit.dart';
import '../../view_model/how_to_make_purchase_states.dart';

class HowToMakePurchaseViewBody extends StatelessWidget {
  const HowToMakePurchaseViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return   BlocProvider(
      create: (context)=>HowToMakePurchaseCubit(getIt.get<HowToMakePurchaseRepoImpl>())..getHowToMakePurchaseData(),
      child: BlocBuilder<HowToMakePurchaseCubit , HowToMakePurchaseStates>(
        builder: (context ,state){
          var howToMakePurchaseCubit = context.read<HowToMakePurchaseCubit>();
          if (state is GetHowToMakePurchaseDataLoadingState) {
            return const CustomLoading();
          }
          else if (state is GetHowToMakePurchaseDataErrorState){
            return const Text("error please try again");
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text("كيف تتم عملية الشراء !",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainColor
                  ),),
                const CustomSizedBox(height: 20,),
                const Text("بيعلي غير مسؤول عن اي عمليه ماليه تحدث بين المشتري والبائع نحن لسنا الا مجرد منصه لوصل المشتري بالبائع",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyColor
                  ),),
                const CustomSizedBox(height: 40,),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context,index){
                      return Row(
                        children: [
                          CachedNetworkImage(imageUrl: "${howToMakePurchaseCubit.allDataHowToMakePurchaseList[index].image}"),
                          const CustomSizedBox(width: 20,),
                          Expanded(
                            child: Column(

                              children: [
                                Text("${howToMakePurchaseCubit.allDataHowToMakePurchaseList[index].title}",
                                style: AppStyles.textStyle16W600Green,),
                                const CustomSizedBox(height: 10,),
                                Text("${howToMakePurchaseCubit.allDataHowToMakePurchaseList[index].message}"),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context,index){
                      return const SizedBox(height:30 ,);
                    },
                    itemCount: 3,
                  ),
                ),
              ],
            ),
          );
        },

      ),
    );
  }
}
