import 'package:by3ly/features/allSubCategoriesProducts/data/models/all_sub_categories_products_model.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import 'all_sub_categories_products_list_item.dart';
import 'products_filter_sheet.dart';

class AllSubCategoriesProductsList extends StatefulWidget {
  const AllSubCategoriesProductsList(
      {super.key, required this.allSubCategoriesProductsList});

  final List<Products> allSubCategoriesProductsList;

  @override
  State<AllSubCategoriesProductsList> createState() =>
      _AllSubCategoriesProductsListState();
}

class _AllSubCategoriesProductsListState
    extends State<AllSubCategoriesProductsList> {
  final TextEditingController _searchController = TextEditingController();
  ProductsFilter _filter = const ProductsFilter.empty();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  double? _productPrice(Products p) {
    final raw = '${p.price ?? ''}'.replaceAll(RegExp(r'[^0-9.]'), '');
    if (raw.isEmpty) return null;
    return double.tryParse(raw);
  }

  List<String> get _availableTypes {
    final set = <String>{};
    for (final p in widget.allSubCategoriesProductsList) {
      final t = (p.type ?? '').trim();
      if (t.isNotEmpty) set.add(t);
    }
    return set.toList()..sort();
  }

  bool _matchesId(dynamic value, int id) {
    if (value == null) return false;
    if (value is int) return value == id;
    if (value is double) return value.toInt() == id;
    if (value is String) return int.tryParse(value.trim()) == id;
    return false;
  }

  List<Products> get _filtered {
    final query = _searchController.text.trim().toLowerCase();
    return widget.allSubCategoriesProductsList.where((p) {
      // Search by name (and description).
      if (query.isNotEmpty) {
        final name = (p.name ?? '').toLowerCase();
        final desc = (p.desc ?? '').toLowerCase();
        if (!name.contains(query) && !desc.contains(query)) return false;
      }
      // Type filter.
      if (_filter.type != null && (p.type ?? '').trim() != _filter.type) {
        return false;
      }
      if (_filter.categoryId != null &&
          !_matchesId(p.categoryId, _filter.categoryId!)) {
        return false;
      }
      if (_filter.subCategoryId != null &&
          !_matchesId(p.subCategoryId, _filter.subCategoryId!)) {
        return false;
      }
      if (_filter.shippingType != null) {
        final s = (p.shippingType ?? '').trim().toLowerCase();
        if (s.isNotEmpty && s != _filter.shippingType) return false;
      }
      if (_filter.condition != null) {
        final c = (p.condition ?? '').trim().toLowerCase();
        if (c.isNotEmpty && c != _filter.condition) return false;
      }
      // Price range filter.
      if (_filter.minPrice != null || _filter.maxPrice != null) {
        final price = _productPrice(p);
        if (price == null) return false;
        if (_filter.minPrice != null && price < _filter.minPrice!) {
          return false;
        }
        if (_filter.maxPrice != null && price > _filter.maxPrice!) {
          return false;
        }
      }
      // Place filter (governorate + optional center).
      if (_filter.cityId != null) {
        final cityMatch = _matchesId(p.cityId, _filter.cityId!) ||
            (_filter.cityName != null &&
                (p.location?.toString() ?? '')
                    .contains(_filter.cityName!));
        if (!cityMatch) return false;
        if (_filter.centerId != null) {
          final centerOk = _matchesId(p.centerId, _filter.centerId!) ||
              (_filter.centerName != null &&
                  (p.location?.toString() ?? '')
                      .contains(_filter.centerName!));
          if (!centerOk) return false;
        } else if (_filter.centerName != null &&
            !(p.location?.toString() ?? '')
                .contains(_filter.centerName!)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  Future<void> _openFilterSheet() async {
    final result = await showModalBottomSheet<ProductsFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ProductsFilterSheet(
        initial: _filter,
        availableTypes: _availableTypes,
      ),
    );
    if (result != null && mounted) {
      setState(() => _filter = result);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final hasActiveSearch = _searchController.text.trim().isNotEmpty;
    final hasActiveFilter = !_filter.isEmpty;

    return Padding(
      padding: EdgeInsets.all(20.0.r),
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
                  suffixIcon: hasActiveSearch
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: _clearSearch,
                        )
                      : null,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              Gap(10.w),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    onTap: _openFilterSheet,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 52.w,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: hasActiveFilter
                            ? AppColors.mainColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: hasActiveFilter
                              ? AppColors.mainColor
                              : const Color.fromRGBO(208, 208, 208, 1),
                        ),
                      ),
                      child: Icon(
                        Icons.tune,
                        color: hasActiveFilter
                            ? AppColors.whiteColor
                            : AppColors.mainColor,
                      ),
                    ),
                  ),
                  if (hasActiveFilter)
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
                          '${_filter.activeCount}',
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Gap(12.h),

          /// Active filter chips (removable).
          if (hasActiveFilter)
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (_filter.categoryId != null)
                    _ActiveFilterChip(
                      label: _filter.categoryName ?? '${_filter.categoryId}',
                      onDeleted: () => setState(
                        () => _filter = _filter.copyWith(
                          clearCategory: true,
                          clearSubCategory: true,
                        ),
                      ),
                    ),
                  if (_filter.subCategoryId != null)
                    _ActiveFilterChip(
                      label: _filter.subCategoryName ??
                          '${_filter.subCategoryId}',
                      onDeleted: () => setState(
                        () => _filter =
                            _filter.copyWith(clearSubCategory: true),
                      ),
                    ),
                  if (_filter.type != null)
                    _ActiveFilterChip(
                      label: _filter.type!,
                      onDeleted: () => setState(
                        () => _filter = _filter.copyWith(clearType: true),
                      ),
                    ),
                  if (_filter.minPrice != null || _filter.maxPrice != null)
                    _ActiveFilterChip(
                      label:
                          '${_filter.minPrice?.toStringAsFixed(0) ?? ''} - ${_filter.maxPrice?.toStringAsFixed(0) ?? ''}',
                      onDeleted: () => setState(
                        () => _filter = _filter.copyWith(clearPrice: true),
                      ),
                    ),
                  if (_filter.cityId != null)
                    _ActiveFilterChip(
                      label: _filter.placeLabel,
                      onDeleted: () => setState(
                        () => _filter = _filter.copyWith(clearPlace: true),
                      ),
                    ),
                  if (_filter.shippingType != null)
                    _ActiveFilterChip(
                      label: _filter.shippingType!,
                      onDeleted: () => setState(
                        () => _filter = _filter.copyWith(clearShipping: true),
                      ),
                    ),
                  if (_filter.condition != null)
                    _ActiveFilterChip(
                      label: _filter.condition!,
                      onDeleted: () => setState(
                        () => _filter = _filter.copyWith(clearCondition: true),
                      ),
                    ),
                ],
              ),
            ),
          if (hasActiveFilter) Gap(8.h),

          /// Results count.
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              '${context.tr(LocaleKeys.productsShow)} (${filtered.length})',
              style: AppStyles.textStyle14W500White.copyWith(
                color: AppColors.greyColor,
              ),
            ),
          ),
          Gap(10.h),

          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64.sp,
                          color: Colors.grey.shade400,
                        ),
                        Gap(12.h),
                        Text(
                          context.tr(LocaleKeys.noResults),
                          textAlign: TextAlign.center,
                          style: AppStyles.textStyle14W500White.copyWith(
                            color: AppColors.greyColor,
                          ),
                        ),
                        Gap(12.h),
                        if (hasActiveSearch || hasActiveFilter)
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _filter = const ProductsFilter.empty();
                              });
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
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.w,
                      // ارتفاع ثابت بدل نسبة عشان ميحصلش overflow على الشاشات الضيقة
                      mainAxisExtent: 235,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return AllSubCategoriesProductsListItem(
                        product: filtered[index],
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
