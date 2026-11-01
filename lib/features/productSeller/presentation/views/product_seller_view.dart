import 'package:by3ly/features/productSeller/presentation/views/product_seller_widgets/product_seller_view_body.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductSellerView extends StatelessWidget {
  const ProductSellerView({super.key, required this.sellerId});
  final int sellerId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        shadowColor: AppColors.mainColor,
        surfaceTintColor:  AppColors.mainColor,
        title: Text(LocaleKeys.sellerData.tr(),style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: ProductSellerViewBody(
        sellerId: sellerId,
      ),
    );
  }
}
