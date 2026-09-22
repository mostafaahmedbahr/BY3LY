 import 'package:by3ly/features/productDetails/presentation/view_model/product_details_cubit.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_states.dart';
import 'package:easy_localization/easy_localization.dart';
 import '../../../../../main_importants.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.imageUrl,
    required this.productId
  });

  final String imageUrl;
  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsCubit, ProductDetailsStates>(
      listener: (context, state) {
        if (state is AddProductToCompareSuccessState) {
          Toast.showSuccessToast(
              msg: state.addProductToCompareModel.message.toString(),
              context: context
          );
          context.read<ProductDetailsCubit>().getProductDetailsData(
              productId: productId,
              type: "home"
          );
        }
        if (state is AddProductToCompareErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.toString()),
            ),
          );
        }
      },
      builder: (context, state) {
        var productDetailsCubit = context.read<ProductDetailsCubit>();
        return SizedBox(
          height: 300,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CustomNetWorkImage(
                height: 300,
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                raduis: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: () {
                    if (state is! AddProductToCompareLoadingState) {
                      productDetailsCubit.addProductToCompare(
                          productId: productId
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state is AddProductToCompareLoadingState)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: AppColors.whiteColor,
                            strokeWidth: 2,
                          ),
                        )
                      else
                        SvgPicture.asset(AppImages.cpmpration),
                      const SizedBox(width: 10),
                      Text(
                        LocaleKeys.compration.tr(),
                        style: AppStyles.textStyle12W600Gary.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}