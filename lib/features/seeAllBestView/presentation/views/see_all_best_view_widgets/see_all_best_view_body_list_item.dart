import 'package:flutter_svg/svg.dart';

import '../../../../../main_importants.dart';
import '../../../../productDetails/presentation/views/product_details_view.dart';
import '../../../data/models/sell_all_best_view_model.dart';
import '../../view_model/sell_all_best_view_cubit.dart';
import '../../view_model/sell_all_best_view_states.dart';

class SeeAllBestViewBodyListItem extends StatelessWidget {
  const SeeAllBestViewBodyListItem({super.key, required this.product});
 final  Products  product;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellAllBestViewCubit , SellAllBestViewStates>(
        listener: (context ,state){},
    builder:  (context ,state) {
         return InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child:   ProductDetailsView(
                  productId: product.id!,
                  type: "home",
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomNetWorkImage(
                imageUrl: "${product.image}",
                raduis: 10,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120,
              ),
              const SizedBox(height: 10,),
              Text("${product.name}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                ),),
              const SizedBox(height: 5,),
              Row(
                children: [
                  SvgPicture.asset(AppImages.location),
                  const SizedBox(width: 5,),
                  Text("${product.address}", style: AppStyles.textStyle10W400Green,),
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text("النوع ", style: AppStyles.textStyle10W400Gray,),
                      Text("${product.type}", style: AppStyles.textStyle10W400Yellow,),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("الاثاث ", style: AppStyles.textStyle10W400Gray,),
                      Text(" ${product.model}", style: AppStyles.textStyle10W400Yellow,),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              Text("${product.price}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 5,),
              Text("${product.createdAt}",
                style: AppStyles.textStyle10W400Green.copyWith(
                  color: const Color(0xff7A7A7A),
                ),),
            ],
          ),
        );
        }

    );
  }
}
