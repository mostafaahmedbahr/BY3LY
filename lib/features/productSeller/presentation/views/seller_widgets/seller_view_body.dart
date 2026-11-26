import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/features/productSeller/data/repos/product_seller_repos_imple.dart';
import 'package:by3ly/features/productSeller/presentation/view_model/product_seller_cubit.dart';
import 'package:by3ly/features/productSeller/presentation/view_model/product_seller_states.dart';
import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/features/productSeller/data/repos/product_seller_repos.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'seller_hero_card.dart';
import 'seller_info_panel.dart';
import 'seller_products_list.dart';
import 'seller_shimmer.dart';
import 'seller_tab_buttons.dart';

/// Seller profile body — branded hero, three premium pill tabs, content
/// sections (profile summary / live ads / previous sales).
class ProductSellerViewBody extends StatelessWidget {
  const ProductSellerViewBody({super.key, required this.sellerId, this.repo});

  final int sellerId;

  /// Optional override — tests inject a fake repo; production leaves this
  /// null and the body resolves [ProductSellerRepoImpl] from the locator.
  final ProductSellerRepo? repo;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductSellerCubit(repo ?? getIt.get<ProductSellerRepoImpl>())
            ..getProductSellerData(sellerId: sellerId),
      child: BlocBuilder<ProductSellerCubit, ProductSellerStates>(
        builder: (context, state) {
          final cubit = ProductSellerCubit.get(context);
          final seller = cubit.productSellerModel?.data?.seller;

          if (state is GetProductSellerDataErrorState && seller == null) {
            return CustomErrorWidget(
              error: state.error,
              onTap: () => cubit.getProductSellerData(sellerId: sellerId),
            );
          }
          if (seller == null) {
            return const SellerShimmer();
          }
          final products = cubit.productSellerModel?.data?.products;

          return SafeArea(
            top: false,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      SellerHeroCard(seller: seller, sellerId: sellerId),
                      const SizedBox(height: 16),
                      const SellerTabButtons(),
                      const SizedBox(height: 14),
                      if (cubit.sellerDataIndex == 1) const SellerInfoPanel(),
                    ]),
                  ),
                ),
                if (cubit.sellerDataIndex == 2 || cubit.sellerDataIndex == 3)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SellerProductsList(products: products),
                  ),
                if ((cubit.sellerDataIndex == 2 ||
                        cubit.sellerDataIndex == 3) &&
                    cubit.hasMore)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: OutlinedButton(
                        onPressed: state is GetProductSellerDataPaginatingState
                            ? null
                            : () => cubit.getProductSellerData(
                                sellerId: sellerId,
                                loadMore: true,
                              ),
                        child: state is GetProductSellerDataPaginatingState
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(context.tr(LocaleKeys.seeMore)),
                      ),
                    ),
                  ),
                if (state is GetProductSellerDataPaginationErrorState)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                      child: Text(
                        state.error,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                // Original ListView had 24px bottom padding. The sliver list
                // above has none, so keep the trailing space here.
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }
}
