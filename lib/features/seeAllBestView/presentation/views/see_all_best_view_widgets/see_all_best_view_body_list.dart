import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_images/app_images.dart';
import 'package:by3ly/features/seeAllBestView/data/models/sell_all_best_view_model.dart';
import 'package:by3ly/features/seeAllBestView/presentation/view_model/sell_all_best_view_cubit.dart';
import 'package:by3ly/features/seeAllBestView/presentation/view_model/sell_all_best_view_states.dart';
import 'package:by3ly/features/seeAllBestView/presentation/views/see_all_best_view_widgets/see_all_best_view_body_list_item.dart';
import 'package:by3ly/features/seeAllBestView/presentation/views/see_all_best_view_widgets/sell_all_best_view_loading.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Grid of the most-viewed ads with a local search box on top.
class SeeAllBestViewBodyList extends StatefulWidget {
  const SeeAllBestViewBodyList({super.key});

  @override
  State<SeeAllBestViewBodyList> createState() =>
      _SeeAllBestViewBodyListState();
}

class _SeeAllBestViewBodyListState extends State<SeeAllBestViewBodyList> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Products> _filtered(List<Products> source) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return source;
    return source.where((p) {
      final name = (p.name ?? '').toLowerCase();
      final desc = (p.desc ?? '').toLowerCase();
      final price = (p.price ?? '').toLowerCase();
      return name.contains(query) ||
          desc.contains(query) ||
          price.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellAllBestViewCubit, SellAllBestViewStates>(
      builder: (context, state) {
        final cubit = SellAllBestViewCubit.get(context);
        if (state is GetAllBestViewProductsLoadingState) {
          return const SellAllBestViewLoading();
        }
        if (state is GetAllBestViewProductsErrorState) {
          return CustomErrorWidget(
            error: state.error,
            onTap: () => cubit.getSellAllBestView(),
          );
        }
        final products = _filtered(
          cubit.sellAllBestViewModel?.data?.products ?? const [],
        );
        return Column(
          children: [
            CustomTextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              hintText: context.tr(LocaleKeys.searchWithBy3ly),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(AppImages.search),
              ),
              suffixIcon: _searchController.text.trim().isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () =>
                          setState(() => _searchController.clear()),
                    )
                  : null,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 56,
                            color: AppColors.border,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchController.text.trim().isNotEmpty
                                ? context.tr(LocaleKeys.noResults)
                                : context.tr(LocaleKeys.noProductsInSection),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.only(bottom: 12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        // Fixed height instead of ratio — avoids vertical
                        // overflows on narrow screens.
                        mainAxisExtent: 235,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return SeeAllBestViewBodyListItem(
                          product: products[index],
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
