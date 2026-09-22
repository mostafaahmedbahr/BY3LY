import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../view_model/product_details_cubit.dart';

class TipsForYourSafety extends StatelessWidget {
  const TipsForYourSafety({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.tipsForYourSafety.tr(),
          style: AppStyles.textStyle16W600Green,),
        const CustomSizedBox(
          height: 5,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context,index){
            return Row(
              children: [
                Container(
                  height: 6,
                  width: 6,
                  color: AppColors.yellowColor,
                ),
                const CustomSizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomRight,
                    child: Text(ProductDetailsCubit.get(context).safetyTipsList[index],
                    ),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context,index){
            return const SizedBox(height: 5,);
          },
          itemCount: ProductDetailsCubit.get(context).safetyTipsList.length,
        ),
      ],
    );
  }
}
