import 'package:flutter_svg/svg.dart';

import '../../../../../main_importants.dart';
import '../../../data/models/product_seller_model.dart';

class SellerImageAndName extends StatelessWidget {
  const SellerImageAndName({super.key, required this.seller});
  final Seller seller;
  @override
  Widget build(BuildContext context) {
    return    Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xffEFEFEF),
              border: Border.all(
                color: const Color(0xffEFEFEF),
              )),
          child: CustomNetWorkImage(
            imageUrl:
            "${seller.image}",
            raduis: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(seller.name.toString(),style: AppStyles.textStyle16W600Black,),
            Row(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(AppImages.star1),
                    const SizedBox(width: 2,),
                    Text("${seller.sellerRate}"),
                  ],
                ),
                const SizedBox(width: 4,),
                Text("( ${seller.countCommenets} )",
                  style: const TextStyle(
                    color: AppColors.greyColor,
                  ),),
              ],
            ) ,
          ],
        ),
      ],
    );
  }
}
