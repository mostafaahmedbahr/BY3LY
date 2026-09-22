import 'package:flutter_svg/svg.dart';

import '../../../../../main_importants.dart';
import '../../../../productDetails/presentation/views/product_details_view.dart';
import '../../../data/models/product_seller_model.dart';

class ProductsOnDisplayNowItem extends StatelessWidget {
  const ProductsOnDisplayNowItem({super.key, required this.product});
  final Products product;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
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
      child: Row(
        children: [
          CustomNetWorkImage(
            imageUrl: "${product.image}",
            raduis: 10,
            fit: BoxFit.cover,
            width: 175,
            height: 120,
          ),
          const  CustomSizedBox(width: 10,),
          Expanded(
            child: SizedBox(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text( "${product.name}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff000000),
                    ),),
                  Row(
                    children: [
                      SvgPicture.asset(AppImages.location),
                      const  CustomSizedBox(width: 5,),
                      Text("${product.address}",style: AppStyles.textStyle10W400Green,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text("النوع ",style: AppStyles.textStyle10W400Gray,),
                          Text(" ${product.type}",style: AppStyles.textStyle10W400Yellow,),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("الاثاث ",style: AppStyles.textStyle10W400Gray,),
                          Text(" ${product.model}",style: AppStyles.textStyle10W400Yellow,),
                        ],
                      ),
                    ],
                  ),
                  Text( "${product.price}",
                      style:const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  Text( "${product.createdAt}",
                    style: AppStyles.textStyle10W400Green.copyWith(
                      color: const Color(0xff7A7A7A),
                    ),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
