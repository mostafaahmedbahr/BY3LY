import 'package:by3ly/core/shared_widgets/app_confirm_dialog.dart';
import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/fav_heart_button.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_cubit.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_states.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/product_details_loading.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/product_details_view_body.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../main_importants.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({
    super.key,
    required this.productId,
    required this.type,
  });

  final int productId;
  final String type;

  @override
  Widget build(BuildContext context) {
    debugPrint(CacheTokenManger.userToken);
    debugPrint("ProductDetailsView");
    return BlocConsumer<ProductDetailsCubit, ProductDetailsStates>(
      listener: (context, state) {
        if (state is PauseResumeAdSuccessState) {
          final message = state.pauseAdResumeAdModel.message?.trim() ?? '';
          Toast.showSuccessToast(
            msg: message.isNotEmpty
                ? message
                : (state.pauseAdResumeAdModel.data?.isPaused == true
                      ? LocaleKeys.pauseAd.tr()
                      : LocaleKeys.resumeAd.tr()),
            context: context,
          );
        } else if (state is PauseResumeAdErrorState) {
          Toast.showErrorToast(msg: state.error, context: context);
        }
      },
      builder: (context, state) {
        var productDetailsCubit = ProductDetailsCubit.get(context);
        if (state is GetProductDetailsDataLoadingState &&
            productDetailsCubit.productDetailsModel?.data?.product == null) {
          return const ProductDetailsLoading();
        }
        if (state is GetProductDetailsDataErrorState &&
            productDetailsCubit.productDetailsModel?.data?.product == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: CustomErrorWidget(
              error: state.error.toString(),
              onTap: () => context
                  .read<ProductDetailsCubit>()
                  .getProductDetailsData(productId: productId, type: type),
            ),
          );
        }
        final product = productDetailsCubit.productDetailsModel?.data?.product;
        final relatedProducts =
            productDetailsCubit.productDetailsModel?.data?.relatedProducts ??
            [];
        if (product == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: CustomErrorWidget(
              onTap: () => context
                  .read<ProductDetailsCubit>()
                  .getProductDetailsData(productId: productId, type: type),
            ),
          );
        }
        // Pause / resume is only available for the seller's own ad.
        final currentUserId = _currentUserId(context);
        final isOwner =
            currentUserId != null && product.seller?.id == currentUserId;
        final isPaused = product.isPaused == true;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            shadowColor: AppColors.mainColor,
            surfaceTintColor: AppColors.mainColor,
            bottom: state is PauseResumeAdLoadingState
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(3),
                    child: LinearProgressIndicator(
                      minHeight: 3,
                      color: AppColors.accent,
                      backgroundColor: AppColors.border,
                    ),
                  )
                : null,
            title: Text(
              product.name ?? '',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Container(
                height: 36,
                width: 36,
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 1.2),
                ),
                child: Center(
                  child: FavHeartButton(
                    productId: productId,
                    initialIsFavourite: product.isFavourite == true,
                    withBackground: false,
                    iconSize: 20,
                  ),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
              if (isOwner)
                PopupMenuButton<String>(
                  tooltip: '',
                  color: AppColors.surface,
                  icon: Icon(Icons.more_vert_sharp, color: AppColors.text),
                  onSelected: (_) =>
                      _confirmPauseResume(context, isPaused: isPaused),
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: isPaused ? 'resume' : 'pause',
                      child: Row(
                        children: [
                          Icon(
                            isPaused
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                            size: 20,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            (isPaused
                                    ? LocaleKeys.resumeAd
                                    : LocaleKeys.pauseAd)
                                .tr(),
                            style: TextStyle(color: AppColors.text),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert_sharp),
                ),
            ],
          ),
          body: ProductDetailsViewBody(
            product: product,
            relatedProducts: relatedProducts,
            type: type,
            isOwner: isOwner,
          ),
        );
      },
    );
  }

  /// Id of the signed-in user, used to detect the seller's own ads.
  int? _currentUserId(BuildContext context) {
    try {
      return ProfileCubit.get(context).profileModel?.data?.user?.id;
    } catch (_) {
      return null;
    }
  }

  Future<void> _confirmPauseResume(
    BuildContext context, {
    required bool isPaused,
  }) async {
    final actionLabel = (isPaused ? LocaleKeys.resumeAd : LocaleKeys.pauseAd)
        .tr();
    final confirmed = await AppConfirmDialog.show(
      context,
      title: actionLabel,
      message:
          (isPaused ? LocaleKeys.resumeAdConfirm : LocaleKeys.pauseAdConfirm)
              .tr(),
      confirmText: actionLabel,
      icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
      accentColor: isPaused ? AppColors.mainColor : AppColors.yellowColor,
    );
    if (!confirmed || !context.mounted) return;

    final cubit = ProductDetailsCubit.get(context);
    if (isPaused) {
      cubit.resumeAd(adId: productId);
    } else {
      cubit.pauseAd(adId: productId);
    }
  }
}
