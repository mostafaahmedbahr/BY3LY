import 'package:by3ly/core/shared_widgets/app_confirm_dialog.dart';
import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/fav_heart_button.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/new_toast/toast.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_cubit.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_states.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/product_details_loading.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/product_details_view_body.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

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
        final productDetailsCubit = ProductDetailsCubit.get(context);
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.darkMainColor,
                    AppColors.mainColor,
                    AppColors.secondColor,
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
            bottom: state is PauseResumeAdLoadingState
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(3),
                    child: LinearProgressIndicator(
                      minHeight: 3,
                      color: AppColors.yellowColor,
                      backgroundColor: Colors.transparent,
                    ),
                  )
                : null,
            title: Text(
              product.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            actions: [
              // Favourites only apply to products you DON'T sell yourself.
              if (!isOwner)
                Container(
                  height: 36,
                  width: 36,
                  margin: const EdgeInsets.only(left: 6),
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
                      favIconColor: AppColors.redColor,
                    ),
                  ),
                ),
              // Share the product link.
              IconButton(
                tooltip: 'Share',
                onPressed: () => _shareProduct(context, product.name),
                icon: const Icon(Icons.share_rounded, color: Colors.white),
              ),
              if (isOwner)
                PopupMenuButton<String>(
                  tooltip: '',
                  color: AppColors.surface,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ),
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
                            color: AppColors.mainColor,
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
                const SizedBox(width: 4),
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

  int? _currentUserId(BuildContext context) {
    try {
      return ProfileCubit.get(context).profileModel?.data?.user?.id;
    } catch (_) {
      return null;
    }
  }

  Future<void> _shareProduct(BuildContext context, String? name) async {
    final text =
        '${context.tr(LocaleKeys.shareProductText)}\n${name ?? ''}';
    try {
      await SharePlus.instance.share(ShareParams(text: text));
    } catch (_) {
      if (!context.mounted) return;
      Toast.showErrorToast(
        msg: 'Could not share this product right now.',
        context: context,
      );
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
      message: (isPaused ? LocaleKeys.resumeAdConfirm : LocaleKeys.pauseAdConfirm)
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
