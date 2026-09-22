import 'package:by3ly/main_importants.dart';

import '../../../../productSeller/presentation/views/product_seller_view.dart';

class ProductSellerInfo extends StatelessWidget {
  const ProductSellerInfo({super.key, required this.sellerName, required this.sellerId});
  final String sellerName;
  final int sellerId;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xffEFEFEF),
              border: Border.all(
                color: const Color(0xffEFEFEF),
              )
          ),
          child:const CustomNetWorkImage(
            imageUrl: "",
            raduis: 50,
            fit: BoxFit.cover,
          ),
        )  ,
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sellerName,style: AppStyles.textStyle16W600Black,),
           ],
        ),
        IconButton(
          onPressed: (){
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child:    ProductSellerView(
                  sellerId: sellerId,
                ),
              ),
            );
          },
          icon: const Icon(Icons.details,color: AppColors.yellowColor,),
        ),
      ],
    );
  }
}
