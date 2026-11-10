import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:by3ly/features/chat/presentation/views/chat_widgets/start_chat_button.dart';
import 'package:by3ly/features/howToMakePurchase/presentation/views/how_to_make_purchase_view.dart';
import 'package:by3ly/features/productDetails/data/models/product_details_model.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_cubit.dart';
import 'package:by3ly/features/productDetails/presentation/view_model/product_details_states.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/name_location_price_des_of_product.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/product_image.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/product_images_list.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/product_seller_info.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/rate_product_widget.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/related_products_widget.dart';
import 'package:by3ly/features/productDetails/presentation/views/product_details_widgets/tips_for_your_safety.dart';
import 'package:by3ly/features/reportProduct/presentation/views/report_the_product_view.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class ProductDetailsViewBody extends StatelessWidget {
  const ProductDetailsViewBody({
    super.key,
    required this.product,
    required this.relatedProducts,
    this.type = 'home',
    this.isOwner = false,
  });

  final Product? product;
  final List<RelatedProducts>? relatedProducts;
  final String type;

  /// True when the signed-in user owns this ad; in that case contacting the
  /// seller (yourself) is disabled.
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsCubit, ProductDetailsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final productDetailsCubit = ProductDetailsCubit.get(context);
        final images = product?.images ?? [];
        final safeIndex = images.isEmpty
            ? 0
            : productDetailsCubit.imageIndex.clamp(0, images.length - 1);
        final mainImage = images.isNotEmpty
            ? images[safeIndex].image.toString()
            : '';
        final seller = product?.seller;

        return ListView(
          physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            ProductImage(
              imageUrl: mainImage,
              productId: product?.id ?? 0,
              images: [for (final img in images) img.image.toString()],
              initialIndex: safeIndex,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImagesList(imagesList: images),
                  const CustomSizedBox(height: 12),
                  NameAndLocationAndPriceAndDesOfProduct(product: product),
                  const CustomSizedBox(height: 14),
                  ProductSellerInfo(
                    sellerName: seller?.name ?? '',
                    sellerId: seller?.id ?? 0,
                    sellerImage: seller?.image ?? '',
                  ),
                  if (product?.id != null && !isOwner) ...[
                    const CustomSizedBox(height: 18),
                    StartChatButton(
                      productId: product!.id,
                      sellerId: seller?.id,
                      builder: (context, isLoading, onPressed) =>
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.mainColor,
                                    AppColors.secondColor,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.mainColor
                                        .withValues(alpha: 0.35),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: isLoading ? null : onPressed,
                                  borderRadius: BorderRadius.circular(15),
                                  child: Center(
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth: 2.2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Row(
                                            mainAxisSize:
                                                MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.chat_bubble_rounded,
                                                color: Colors.white,
                                                size: 19,
                                              ),
                                              const SizedBox(width: 9),
                                              Text(
                                                context.tr(LocaleKeys
                                                    .contactSeller),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.w800,
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ),
                  ],
                  const CustomSizedBox(height: 16),
                  if (product?.id != null && !isOwner)
                    RateProductWidget(
                      productId: product!.id!,
                      type: type,
                      currentRate: product?.rate,
                      reviewsCount: product?.reviewsCount,
                    ),
                  if (product?.id != null) const CustomSizedBox(height: 16),
                  const CustomSizedBox(height: 4),
                  Text(
                    context.tr(LocaleKeys.aboutProduct),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                  const CustomSizedBox(height: 10),
                  const TipsForYourSafety(),
                  const CustomSizedBox(height: 18),
                  // Outline help-link to purchase instructions.
                  _OutlineAction(
                    icon: Icons.shopping_cart_outlined,
                    label: context.tr(LocaleKeys.howToPurchase),
                    onTap: () => Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: const HowToMakePurchaseView(),
                      ),
                    ),
                  ),
                  const CustomSizedBox(height: 10),
                  // Outline support-link that opens the report flow.
                  _OutlineAction(
                    icon: Icons.flag_rounded,
                    label: context.tr(LocaleKeys.reportingAndSupport),
                    onTap: () async {
                      if (!await GuestGuard.requireLogin(context)) return;
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: ReportTheProductView(
                            productId: product?.id,
                            sellerId: seller?.id,
                          ),
                        ),
                      );
                    },
                  ),
                  const CustomSizedBox(height: 20),
                  RelatedProductsWidget(
                    relatedProducts: relatedProducts,
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

/// Premium outline action row — icon chip on the left, bold label, chevron right.
class _OutlineAction extends StatelessWidget {
  const _OutlineAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 1.1),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.mainColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
