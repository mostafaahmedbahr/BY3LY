 import 'package:by3ly/features/productSeller/data/repos/product_seller_repos_imple.dart';
import 'package:by3ly/features/productSeller/presentation/view_model/product_seller_states.dart';
import 'package:by3ly/features/productSeller/presentation/views/product_seller_widgets/previous_sales_products.dart';
import 'package:by3ly/features/productSeller/presentation/views/product_seller_widgets/product_seller_reviews_info.dart';
import 'package:by3ly/features/productSeller/presentation/views/product_seller_widgets/products_on_display_now.dart';
import 'package:by3ly/features/productSeller/presentation/views/product_seller_widgets/seller_contact_button.dart';
import 'package:by3ly/features/productSeller/presentation/views/product_seller_widgets/seller_image_and_name.dart';
import 'package:by3ly/features/productSeller/presentation/views/product_seller_widgets/seller_taps_buttons.dart';
import 'package:by3ly/main_importants.dart';
  import '../../view_model/product_seller_cubit.dart';
class ProductSellerViewBody extends StatelessWidget {
  const ProductSellerViewBody({super.key, required this.sellerId});
  final int sellerId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductSellerCubit(getIt.get<ProductSellerRepoImpl>())
            ..getProductSellerData(sellerId: sellerId),
      child: BlocBuilder<ProductSellerCubit, ProductSellerStates>(
        builder: (context, state) {
          var productSellerCubit = ProductSellerCubit.get(context);
          if (state is GetProductSellerDataLoadingState) {
            return const CustomLoading();
          }
          if (state is GetProductSellerDataErrorState) {
            return Center(
                child: Text(state.error,
                    style: const TextStyle(color: Colors.red)));
          }
          var seller = productSellerCubit.productSellerModel!.data!.seller!;
          var products = productSellerCubit.productSellerModel!.data!.products!;
          return
            Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
                children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SellerImageAndName(seller: seller,),
                  const SellerContactButton(),
                ],
              ),
                  const CustomSizedBox(height: 20,),
                  const SellerTapsButtons(),
                  const CustomSizedBox(height: 20,),
                  if(productSellerCubit.sellerDataIndex==1)
                  const ProductSellerReviewsInfo(),
                  if(productSellerCubit.sellerDataIndex==2)
                      ProductsOnDisplayNow(
                      products: products,
                    ),
                  if(productSellerCubit.sellerDataIndex==3)
                      PreviousSalesProducts(
                      products: products,
                    ),
                ]
            ),
          );
        },
      ),
    );
  }
}
