import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/allSubCategoriesProducts/presentation/views/all_sub_categories_products_widgets/products_filter_sheet.dart';
import 'package:by3ly/features/search/data/models/all_products_search_model.dart';
import 'package:by3ly/features/search/presentation/view_model/search_cubit.dart';
import 'package:by3ly/features/search/presentation/view_model/search_states.dart';
import 'package:by3ly/features/search/presentation/views/search_widgets/search_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/shared_widgets/custom_text_form_filed.dart';
import '../../../../../core/utils/app_images/app_images.dart';
import '../../../../../core/utils/app_styles/app_styles.dart';
import '../../../../../lang/locale_keys.dart';
import 'all_products_search_list_loading.dart';

class SearchViewBody extends StatefulWidget {
  const SearchViewBody({super.key});

  @override
  State<SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<SearchViewBody> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    // Load the next page a bit before reaching the very bottom.
    if (max - current <= 300) {
      SearchCubit.get(context).getAllProductsForSearch(loadMore: true);
    }
  }

  double? _productPrice(Products p) {
    final raw = (p.price ?? '').replaceAll(RegExp(r'[^0-9.]'), '');
    if (raw.isEmpty) return null;
    return double.tryParse(raw);
  }

  bool _matchesId(dynamic value, int id) {
    if (value == null) return false;
    if (value is int) return value == id;
    if (value is double) return value.toInt() == id;
    if (value is String) return int.tryParse(value.trim()) == id;
    return false;
  }

  List<Products> _filtered(List<Products> source, ProductsFilter filter) {
    final query = _searchController.text.trim().toLowerCase();
    return source.where((p) {
      if (query.isNotEmpty) {
        final name = (p.name ?? '').toLowerCase();
        final desc = (p.desc ?? '').toLowerCase();
        if (!name.contains(query) && !desc.contains(query)) return false;
      }
      if (filter.type != null && (p.type ?? '').trim() != filter.type) {
        return false;
      }
      if (filter.minPrice != null || filter.maxPrice != null) {
        final price = _productPrice(p);
        if (price == null) return false;
        if (filter.minPrice != null && price < filter.minPrice!) return false;
        if (filter.maxPrice != null && price > filter.maxPrice!) return false;
      }
      if (filter.cityId != null) {
        final cityMatch = _matchesId(p.cityId, filter.cityId!) ||
            (filter.cityName != null &&
                (p.location?.toString() ?? '')
                    .contains(filter.cityName!));
        if (!cityMatch) return false;
        if (filter.centerId != null &&
            filter.centerName != null &&
            !(p.location?.toString() ?? '')
                .contains(filter.centerName!)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  List<String> _availableTypes(List<Products> source) {
    final set = <String>{};
    for (final p in source) {
      final t = (p.type ?? '').trim();
      if (t.isNotEmpty) set.add(t);
    }
    return set.toList()..sort();
  }

  Future<void> _openFilterSheet() async {
    final cubit = SearchCubit.get(context);
    final result = await showProductsFilterSheet(
      context: context,
      initial: cubit.searchFilter,
      availableTypes: _availableTypes(cubit.allProductsForSearchList),
    );
    if (result != null && mounted) {
      cubit.applySearchFilter(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
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
              ),
              const SizedBox(width: 10),
              BlocBuilder<SearchCubit, SearchStates>(
                buildWhen: (prev, curr) => curr is SearchFilterChanged,
                builder: (context, state) {
                  final filter = SearchCubit.get(context).searchFilter;
                  final active = !filter.isEmpty;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        onTap: _openFilterSheet,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.mainColor
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: active
                                  ? AppColors.mainColor
                                  : const Color.fromRGBO(208, 208, 208, 1),
                            ),
                          ),
                          child: Icon(
                            Icons.tune,
                            color: active
                                ? AppColors.whiteColor
                                : AppColors.mainColor,
                          ),
                        ),
                      ),
                      if (active)
                        Positioned.directional(
                          textDirection: Directionality.of(context),
                          top: -6,
                          start: -6,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: AppColors.redColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${filter.activeCount}',
                              style: const TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          const CustomSizedBox(height: 12),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchStates>(
              builder: (context, state) {
                final cubit = context.read<SearchCubit>();

                if (state is GetAllProductsForSearchLoading &&
                    cubit.allProductsForSearchList.isEmpty) {
                  return const AllProductsSearchListLoading();
                }
                if (state is GetAllProductsForSearchError &&
                    cubit.allProductsForSearchList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                        ),
                        const CustomSizedBox(height: 12),
                        CustomButton(
                          width: 160,
                          btnText: Text(
                            context.tr(LocaleKeys.search),
                            style: AppStyles.textStyle14W500White,
                          ),
                          onPressed: () =>
                              cubit.getAllProductsForSearch(),
                        ),
                      ],
                    ),
                  );
                }

                final filter = cubit.searchFilter;
                final items =
                    _filtered(cubit.allProductsForSearchList, filter);
                final hasActiveSearch =
                    _searchController.text.trim().isNotEmpty;

                return Column(
                  children: [
                    /// Active filter chips (removable).
                    if (!filter.isEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (filter.type != null)
                              _ActiveFilterChip(
                                label: filter.type!,
                                onDeleted: () => cubit.applySearchFilter(
                                  ProductsFilter(
                                    minPrice: filter.minPrice,
                                    maxPrice: filter.maxPrice,
                                    cityId: filter.cityId,
                                    cityName: filter.cityName,
                                    centerId: filter.centerId,
                                    centerName: filter.centerName,
                                  ),
                                ),
                              ),
                            if (filter.minPrice != null ||
                                filter.maxPrice != null)
                              _ActiveFilterChip(
                                label:
                                    '${filter.minPrice?.toStringAsFixed(0) ?? ''} - ${filter.maxPrice?.toStringAsFixed(0) ?? ''}',
                                onDeleted: () => cubit.applySearchFilter(
                                  ProductsFilter(
                                    type: filter.type,
                                    cityId: filter.cityId,
                                    cityName: filter.cityName,
                                    centerId: filter.centerId,
                                    centerName: filter.centerName,
                                  ),
                                ),
                              ),
                            if (filter.cityId != null)
                              _ActiveFilterChip(
                                label: filter.placeLabel,
                                onDeleted: () => cubit.applySearchFilter(
                                  ProductsFilter(
                                    type: filter.type,
                                    minPrice: filter.minPrice,
                                    maxPrice: filter.maxPrice,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    if (!filter.isEmpty) const CustomSizedBox(height: 8),

                    /// Results count.
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        '${context.tr(LocaleKeys.productsShow)} (${items.length})',
                        style: AppStyles.textStyle14W500White.copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                    ),
                    const CustomSizedBox(height: 8),

                    Expanded(
                      child: items.isEmpty && !cubit.isLoadingMore
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  const CustomSizedBox(height: 12),
                                  Text(
                                    context.tr(LocaleKeys.noResults),
                                    textAlign: TextAlign.center,
                                    style: AppStyles.textStyle14W500White
                                        .copyWith(
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                  const CustomSizedBox(height: 12),
                                  if (hasActiveSearch || !filter.isEmpty)
                                    TextButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        cubit.clearSearchFilter();
                                        setState(() {});
                                      },
                                      child: Text(
                                        context.tr(LocaleKeys.clearAll),
                                        style: const TextStyle(
                                          color: AppColors.mainColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              controller: _scrollController,
                              itemCount: items.length +
                                  ((cubit.isLoadingMore ||
                                          state
                                              is GetAllProductsForSearchPaginationError)
                                      ? 1
                                      : 0),
                              itemBuilder: (context, index) {
                                if (index >= items.length) {
                                  if (state
                                      is GetAllProductsForSearchPaginationError) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      child: Column(
                                        children: [
                                          Text(
                                            state.message,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 12),
                                          ),
                                          TextButton(
                                            onPressed: () => cubit
                                                .getAllProductsForSearch(
                                                    loadMore: true),
                                            child: Text(
                                              context.tr(LocaleKeys.search),
                                              style: const TextStyle(
                                                color: AppColors.mainColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: SizedBox(
                                        width: 28,
                                        height: 28,
                                        child:
                                            CircularProgressIndicator(
                                                strokeWidth: 2.5),
                                      ),
                                    ),
                                  );
                                }
                                return SearchItemWidget(
                                    product: items[index]);
                              },
                              separatorBuilder: (context, index) {
                                return const CustomSizedBox(height: 20);
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  const _ActiveFilterChip({required this.label, required this.onDeleted});

  final String label;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: AppColors.whiteColor,
          fontSize: 12,
        ),
      ),
      backgroundColor: AppColors.mainColor,
      deleteIcon: const Icon(
        Icons.close,
        size: 16,
        color: AppColors.whiteColor,
      ),
      onDeleted: onDeleted,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.zero,
    );
  }
}
