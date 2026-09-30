import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/fav_heart_button.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_cubit.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_states.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/product_details_view_body.dart';
import '../../../../main_importants.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView(
      {super.key, required this.productId, required this.type});

  final int productId;
  final String type;

  @override
  Widget build(BuildContext context) {
    debugPrint(CacheTokenManger.userToken);
    debugPrint("ProductDetailsView");
    return BlocBuilder<ProductDetailsCubit, ProductDetailsStates>(
      builder: (context, state) {
        var productDetailsCubit = ProductDetailsCubit.get(context);
        if (state is GetProductDetailsDataLoadingState &&
            productDetailsCubit.productDetailsModel?.data?.product == null) {
          return const Scaffold(body: CustomLoading());
        }
        if (state is GetProductDetailsDataErrorState &&
            productDetailsCubit.productDetailsModel?.data?.product == null) {
          return Scaffold(
            body: CustomErrorWidget(
              error: state.error.toString(),
              onTap: () => context
                  .read<ProductDetailsCubit>()
                  .getProductDetailsData(
                      productId: productId, type: type),
            ),
          );
        }
        final product =
            productDetailsCubit.productDetailsModel?.data?.product;
        final relatedProducts = productDetailsCubit
                .productDetailsModel?.data?.relatedProducts ??
            [];
        if (product == null) {
          return Scaffold(
            body: CustomErrorWidget(
              onTap: () => context
                  .read<ProductDetailsCubit>()
                  .getProductDetailsData(
                      productId: productId, type: type),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            shadowColor: AppColors.mainColor,
            surfaceTintColor: AppColors.mainColor,
            title: Text(
              product.name ?? '',
              style: const TextStyle(
                  color: AppColors.blackColor, fontWeight: FontWeight.bold),
            ),
                      actions: [
                        Container(
                          height: 36,
                          width: 36,
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE8E8E8),
                              width: 1.2,
                            ),
                          ),
                          child: Center(
                            child: FavHeartButton(
                              productId: productId,
                              initialIsFavourite:
                                  product.isFavourite == true,
                              withBackground: false,
                              iconSize: 20,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                        ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_sharp),
              ),
            ],
          ),
          body: ProductDetailsViewBody(
            product: product,
            relatedProducts: relatedProducts,
          ),
        );
      },
    );
  }
}
