
import 'package:by3ly/features/howToMakePurchase/presentation/views/how_to_make_purchase_view.dart';
import 'package:by3ly/features/productDetails/data/models/product_details_model.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_cubit.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_states.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/name_location_price_des_of_product.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/product_image.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/product_images_list.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/product_seller_info.dart';
 import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/related_products_widget.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/tips_for_your_safety.dart';
import 'package:by3ly/features/reportProduct/presentation/views/report_the_product_view.dart';
import 'package:easy_localization/easy_localization.dart';
 import '../../../../../main_importants.dart';

class ProductDetailsViewBody extends StatelessWidget {
  const ProductDetailsViewBody({super.key,required this.product,required this.relatedProducts});
  final Product? product;
  final List<RelatedProducts>? relatedProducts;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsCubit, ProductDetailsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var productDetailsCubit = ProductDetailsCubit.get(context);
        final images = product?.images ?? [];
        final safeIndex = images.isEmpty
            ? 0
            : productDetailsCubit.imageIndex.clamp(0, images.length - 1);
        final mainImage =
            images.isNotEmpty ? images[safeIndex].image.toString() : '';
        final seller = product?.seller;
        return ListView(
          children: [
              ProductImage(
                  imageUrl: mainImage,
              productId: product?.id ?? 0,),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    ProductImagesList(
                      imagesList: images,
                    ),
                  const CustomSizedBox(
                    height: 10,
                  ),
                    NameAndLocationAndPriceAndDesOfProduct(
                    product: product,
                  ),
                  const CustomSizedBox(
                    height: 10,
                  ),
                  ProductSellerInfo(
                      sellerName: seller?.name ?? '',
                      sellerId: seller?.id ?? 0,
                      sellerImage: seller?.image ?? '',
                  ),
                  const CustomSizedBox(
                    height: 10,
                  ),
                    Text(LocaleKeys.aboutProduct.tr(),
                  style: AppStyles.textStyle16W600Black,),
                  const CustomSizedBox(
                    height: 10,
                  ),
                   const TipsForYourSafety(),
                  const CustomSizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    btnColor: AppColors.whiteColor,
                      btnText: const Text("كيم تتم عملية الشراء !",style: TextStyle(
                        color: AppColors.mainColor,
                      ),),
                      onPressed: (){
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child:  const HowToMakePurchaseView(),
                          ),
                        );
                      },
                  ),
                  const CustomSizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    btnColor: AppColors.whiteColor,
                    btnText:   Text( LocaleKeys.reportingAndSupport.tr(),style: const TextStyle(
                      color: AppColors.mainColor,
                    ),),
                      onPressed: (){
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child:    ReportTheProductView(
                              productId:product?.id,
                              sellerId: seller?.id,
                            ),
                          ),
                        );
                      },
                  ),
                  const CustomSizedBox(
                    height: 20,
                  ),
                  RelatedProductsWidget(
                      relatedProducts : relatedProducts,
                  ),

                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
