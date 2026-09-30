import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_states.dart';
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
                        BlocBuilder<FavCubit, FavStates>(
                          builder: (context, favState) {
                            final favCubit = FavCubit.get(context);
                            final isFav = favCubit.isFavourite(productId) ||
                                product.isFavourite == true;
                            return IconButton(
                              onPressed: () => favCubit.toggleFavourite(
                                  productId: productId),
                              icon: Icon(
                                isFav
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFav ? AppColors.redColor : null,
                              ),
                            );
                          },
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
