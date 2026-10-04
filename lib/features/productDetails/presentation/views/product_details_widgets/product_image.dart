  import 'package:by3ly/core/shared_widgets/full_screen_gallery.dart';
import 'package:by3ly/features/compare/presentation/view_model/compare_cubit.dart';
import 'package:by3ly/features/compare/presentation/view_model/compare_states.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_cubit.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_states.dart';
import 'package:easy_localization/easy_localization.dart';
  import '../../../../../main_importants.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.imageUrl,
    required this.productId,
    this.images = const [],
    this.initialIndex = 0,
  });

  final String imageUrl;
  final int productId;

  /// All gallery urls (falls back to [imageUrl] when empty).
  final List<String> images;
  final int initialIndex;

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
        return SizedBox(
          height: 300,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              InkWell(
                onTap: () {
                  final urls = images.isNotEmpty
                      ? images
                      : [imageUrl];
                  FullScreenGallery.open(
                    context,
                    images: urls,
                    initialIndex: initialIndex,
                  );
                },
                child: CustomNetWorkImage(
                  height: 300,
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  raduis: 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocBuilder<CompareCubit, CompareStates>(
                  builder: (context, compareState) {
                    final compareCubit = CompareCubit.get(context);
                    final inBasket = compareCubit.isInBasket(productId);
                    return InkWell(
                      onTap: () {
                        final added =
                            compareCubit.toggleBasket(productId);
                        if (added) {
                          if (compareCubit.basketIds.length >= 2) {
                            context.pushNamed(Routes.compareView);
                          } else {
                            Toast.showSuccessToast(
                              msg:
                                  '${context.tr(LocaleKeys.addToCompare)} (${compareCubit.basketIds.length}/2)',
                              context: context,
                            );
                          }
                        } else {
                          Toast.showSuccessToast(
                            msg: context
                                .tr(LocaleKeys.removeFromCompare),
                            context: context,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: inBasket
                              ? AppColors.mainColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: inBasket
                                ? AppColors.mainColor
                                : const Color(0xFFE8E8E8),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppImages.cpmpration,
                              width: 20,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                inBasket
                                    ? Colors.white
                                    : AppColors.mainColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              LocaleKeys.compration.tr(),
                              style: AppStyles.textStyle12W600Gary.copyWith(
                                color: inBasket
                                    ? Colors.white
                                    : const Color(0xff1F2937),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}