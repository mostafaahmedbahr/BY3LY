import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/product_details_view_body.dart';
import '../../../../main_importants.dart';
import '../view_model/product_details_cubit.dart';
import '../view_model/product_details_states.dart';

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
        return state is GetProductDetailsDataLoadingState
            ? const Scaffold(body: CustomLoading())
            : state is GetProductDetailsDataErrorState
                ? const Scaffold(body: Text("Error"))
                : Scaffold(
                    appBar: AppBar(
                      backgroundColor: AppColors.whiteColor,
                      shadowColor: AppColors.mainColor,
                      surfaceTintColor: AppColors.mainColor,
                      title: Text(
                        "${productDetailsCubit.productDetailsModel!.data!.product!.name}",
                        style: const TextStyle(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_border),
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
                      product: productDetailsCubit
                          .productDetailsModel!.data!.product!,
                      relatedProducts: productDetailsCubit
                          .productDetailsModel!.data!.relatedProducts!,
                    ),
                  );
      },
    );
  }
}
