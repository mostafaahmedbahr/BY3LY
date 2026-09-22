import 'package:easy_localization/easy_localization.dart';
 import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import '../../../../../main_importants.dart';
import '../../../data/models/product_details_model.dart';

class NameAndLocationAndPriceAndDesOfProduct extends StatelessWidget {
  const NameAndLocationAndPriceAndDesOfProduct({super.key, this.product});
  final Product? product;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${product!.name}",
          style: AppStyles.textStyle16W600Black,
        ),
        const CustomSizedBox(
          height: 10,
        ),
        Row(
          children: [
            SvgPicture.asset(AppImages.location),
            const CustomSizedBox(
              width: 10,
            ),
            Text(
              "${product!.address}",
              style: AppStyles.textStyle14W500White
                  .copyWith(color: AppColors.mainColor),
            ),
          ],
        ),
        const CustomSizedBox(
          height: 10,
        ),
        Text(
          "${product!.price}",
        style: AppStyles.textStyle16W600Black,
                    ),
                    const CustomSizedBox(
        width: 5,
                    ),
        const CustomSizedBox(
          height: 10,
        ),
        Text(LocaleKeys.desAboutProduct.tr(),
          style: AppStyles.textStyle16W600Black,
        ),
        const CustomSizedBox(
          height: 10,
        ),
        ReadMoreText(
          "${product!.desc}",
          trimLines: 2,
          colorClickableText: AppColors.yellowColor,
          trimMode: TrimMode.Line,
          trimCollapsedText: LocaleKeys.seeMore.tr(),
          trimExpandedText: LocaleKeys.seeLess.tr(),
          style: const TextStyle(
              fontSize: 16
          ),
          moreStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.mainColor
          ),
        ),
      ],
    );
  }
}
