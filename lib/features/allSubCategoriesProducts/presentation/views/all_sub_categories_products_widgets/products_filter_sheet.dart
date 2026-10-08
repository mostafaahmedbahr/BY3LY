import 'package:by3ly/features/allCategories/data/models/all_categoies_model.dart' as cats;
import 'package:by3ly/features/allSubCategories/data/models/all_sub_categories_model.dart' as subs;
import 'package:by3ly/features/allCategories/data/repositories/all_categories_repo_imple.dart';
import 'package:by3ly/features/allSubCategories/data/repos/all_sub_categories_repos_imple.dart';
import 'package:by3ly/features/chooseLocation/data/models/cities_centers_model.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_cubit.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_states.dart';
import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/shared_widgets/custom_button.dart';
import '../../../../../core/shared_widgets/custom_text_form_filed.dart';
import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../../../../core/utils/app_styles/app_styles.dart';
import '../../../../../lang/locale_keys.dart';

/// Immutable holder for the filters applied on the products grid.
///
/// Server keys: category_id, sub_category_id, min_price, max_price,
/// city_id, center_id, shipping_type (free/paid), condition (new/used).
/// `both` for shipping/condition means "no filter" (null).
///
/// The place filter uses the same cities/centers data as the
/// ChooseLocation screen and account creation (ChooseLocationCubit).
class ProductsFilter {
  final String? type;
  final double? minPrice;
  final double? maxPrice;
  final int? cityId;
  final String? cityName;
  final int? centerId;
  final String? centerName;
  final int? categoryId;
  final String? categoryName;
  final int? subCategoryId;
  final String? subCategoryName;
  final String? shippingType; // 'free' | 'paid' | null(=both)
  final String? condition; // 'new' | 'used' | null(=both)

  const ProductsFilter({
    this.type,
    this.minPrice,
    this.maxPrice,
    this.cityId,
    this.cityName,
    this.centerId,
    this.centerName,
    this.categoryId,
    this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.shippingType,
    this.condition,
  });

  const ProductsFilter.empty()
      : type = null,
        minPrice = null,
        maxPrice = null,
        cityId = null,
        cityName = null,
        centerId = null,
        centerName = null,
        categoryId = null,
        categoryName = null,
        subCategoryId = null,
        subCategoryName = null,
        shippingType = null,
        condition = null;

  bool get isEmpty =>
      type == null &&
      minPrice == null &&
      maxPrice == null &&
      cityId == null &&
      categoryId == null &&
      subCategoryId == null &&
      shippingType == null &&
      condition == null;

  int get activeCount =>
      (type != null ? 1 : 0) +
      (minPrice != null ? 1 : 0) +
      (maxPrice != null ? 1 : 0) +
      (cityId != null ? 1 : 0) +
      (categoryId != null ? 1 : 0) +
      (subCategoryId != null ? 1 : 0) +
      (shippingType != null ? 1 : 0) +
      (condition != null ? 1 : 0);

  /// Label shown on the active-filter chip, e.g. "القاهرة - مدينة نصر".
  String get placeLabel {
    if (cityName == null) return '';
    if (centerName != null) return '$cityName - $centerName';
    return cityName!;
  }

  /// Query params for GET products? — nulls omitted, `both` already null.
  Map<String, dynamic> toQueryParams() {
    final map = <String, dynamic>{};
    if (categoryId != null) map['category_id'] = categoryId;
    if (subCategoryId != null) map['sub_category_id'] = subCategoryId;
    if (minPrice != null) map['min_price'] = minPrice;
    if (maxPrice != null) map['max_price'] = maxPrice;
    if (cityId != null) map['city_id'] = cityId;
    if (centerId != null) map['center_id'] = centerId;
    if (shippingType != null) map['shipping_type'] = shippingType;
    if (condition != null) map['condition'] = condition;
    return map;
  }

  ProductsFilter copyWith({
    String? type,
    double? minPrice,
    double? maxPrice,
    int? cityId,
    String? cityName,
    int? centerId,
    String? centerName,
    int? categoryId,
    String? categoryName,
    int? subCategoryId,
    String? subCategoryName,
    String? shippingType,
    String? condition,
    bool clearType = false,
    bool clearPrice = false,
    bool clearPlace = false,
    bool clearCategory = false,
    bool clearSubCategory = false,
    bool clearShipping = false,
    bool clearCondition = false,
  }) {
    return ProductsFilter(
      type: clearType ? null : (type ?? this.type),
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
      cityId: clearPlace ? null : (cityId ?? this.cityId),
      cityName: clearPlace ? null : (cityName ?? this.cityName),
      centerId: clearPlace ? null : (centerId ?? this.centerId),
      centerName: clearPlace ? null : (centerName ?? this.centerName),
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      categoryName: clearCategory ? null : (categoryName ?? this.categoryName),
      subCategoryId:
          clearSubCategory ? null : (subCategoryId ?? this.subCategoryId),
      subCategoryName:
          clearSubCategory ? null : (subCategoryName ?? this.subCategoryName),
      shippingType: clearShipping ? null : (shippingType ?? this.shippingType),
      condition: clearCondition ? null : (condition ?? this.condition),
    );
  }
}

/// Opens the shared products filter bottom sheet and returns the
/// filter picked by the user (or null if dismissed).
Future<ProductsFilter?> showProductsFilterSheet({
  required BuildContext context,
  required ProductsFilter initial,
  required List<String> availableTypes,
}) {
  return showModalBottomSheet<ProductsFilter>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.whiteColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => ProductsFilterSheet(
      initial: initial,
      availableTypes: availableTypes,
    ),
  );
}

/// Bottom sheet that lets the user pick type / price range / place
/// (governorate + center from the shared cities list).
class ProductsFilterSheet extends StatefulWidget {
  const ProductsFilterSheet({
    super.key,
    required this.initial,
    required this.availableTypes,
  });

  final ProductsFilter initial;
  final List<String> availableTypes;

  @override
  State<ProductsFilterSheet> createState() => _ProductsFilterSheetState();
}

class _ProductsFilterSheetState extends State<ProductsFilterSheet> {
  String? _type;
  int? _cityId;
  int? _centerId;
  int? _categoryId;
  int? _subCategoryId;
  String? _shippingType; // null = both
  String? _condition; // null = both
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  List<cats.Categories> _categories = [];
  List<subs.SubCategories> _subCategories = [];
  bool _loadingCats = false;
  bool _loadingSubs = false;
  String? _catsError;

  List<Centers> _centersForCity(List<Cities> cities, int? cityId) {
    if (cityId == null) return const [];
    for (final city in cities) {
      if (city.id == cityId) return city.centers ?? [];
    }
    return const [];
  }

  @override
  void initState() {
    super.initState();
    _type = widget.initial.type;
    _cityId = widget.initial.cityId;
    _centerId = widget.initial.centerId;
    _categoryId = widget.initial.categoryId;
    _subCategoryId = widget.initial.subCategoryId;
    _shippingType = widget.initial.shippingType;
    _condition = widget.initial.condition;
    _minController = TextEditingController(
      text: widget.initial.minPrice?.toStringAsFixed(0) ?? '',
    );
    _maxController = TextEditingController(
      text: widget.initial.maxPrice?.toStringAsFixed(0) ?? '',
    );
    // If the shared cities list hasn't loaded yet (slow network on app
    // start), fetch it now so the dropdowns appear without reopening.
    final locationCubit = ChooseLocationCubit.get(context);
    if (locationCubit.allCitiesList.isEmpty) {
      locationCubit.getAllCitiesAndCenters();
    }
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _loadingCats = true;
      _catsError = null;
    });
    try {
      final result =
          await getIt<AllCategoriesRepoImpl>().getAllCategories();
      result.fold(
        (failure) {
          if (!mounted) return;
          setState(() {
            _loadingCats = false;
            _catsError = failure.errMessage;
          });
        },
        (data) {
          if (!mounted) return;
          setState(() {
            _loadingCats = false;
            _categories = data.data?.categories ?? [];
          });
          // Load sub-categories if a category was pre-selected.
          if (_categoryId != null) _loadSubCategories(_categoryId!);
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingCats = false;
        _catsError = e.toString();
      });
    }
  }

  Future<void> _loadSubCategories(int categoryId) async {
    setState(() {
      _loadingSubs = true;
      _subCategories = [];
    });
    try {
      final result = await getIt<AllSubCategoriesRepoImpl>()
          .getAllSubCategoriesData(categoryId: categoryId);
      result.fold(
        (failure) {
          if (!mounted) return;
          setState(() => _loadingSubs = false);
        },
        (data) {
          if (!mounted) return;
          setState(() {
            _loadingSubs = false;
            _subCategories = data.data?.subCategories ?? [];
          });
        },
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingSubs = false);
    }
  }

  void _onCategoryChanged(int? value) {
    setState(() {
      _categoryId = value;
      // Reset dependent sub-category when the category changes.
      _subCategoryId = null;
      _subCategories = [];
    });
    if (value != null) _loadSubCategories(value);
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _clearAll() {
    setState(() {
      _type = null;
      _cityId = null;
      _centerId = null;
      _categoryId = null;
      _subCategoryId = null;
      _subCategories = [];
      _shippingType = null;
      _condition = null;
      _minController.clear();
      _maxController.clear();
    });
  }

  void _apply() {
    final cities = ChooseLocationCubit.get(context).allCitiesList;
    String? cityName;
    String? centerName;
    for (final city in cities) {
      if (city.id == _cityId) {
        cityName = city.name;
        if (_centerId != null) {
          for (final center in city.centers ?? <Centers>[]) {
            if (center.id == _centerId) {
              centerName = center.name;
              break;
            }
          }
        }
        break;
      }
    }
    String? categoryName;
    for (final c in _categories) {
      if (c.id == _categoryId) {
        categoryName = c.name;
        break;
      }
    }
    String? subCategoryName;
    for (final s in _subCategories) {
      if (s.id == _subCategoryId) {
        subCategoryName = s.name;
        break;
      }
    }
    // Fall back to initial names when lists haven't loaded yet
    // (e.g. reopening the sheet offline with an active filter).
    categoryName ??= widget.initial.categoryId == _categoryId
        ? widget.initial.categoryName
        : null;
    subCategoryName ??= widget.initial.subCategoryId == _subCategoryId
        ? widget.initial.subCategoryName
        : null;
    Navigator.pop(
      context,
      ProductsFilter(
        type: _type,
        minPrice: double.tryParse(_minController.text.trim()),
        maxPrice: double.tryParse(_maxController.text.trim()),
        cityId: _cityId,
        cityName: cityName ?? widget.initial.cityName,
        centerId: _centerId,
        centerName: centerName ?? widget.initial.centerName,
        categoryId: _categoryId,
        categoryName: categoryName,
        subCategoryId: _subCategoryId,
        subCategoryName: subCategoryName,
        shippingType: _shippingType,
        condition: _condition,
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      fillColor: AppColors.whiteColor,
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.mainColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color.fromRGBO(208, 208, 208, 1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color.fromRGBO(208, 208, 208, 1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color.fromRGBO(208, 208, 208, 1)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr(LocaleKeys.filter),
                    style: AppStyles.textStyle16W600Black,
                  ),
                  TextButton(
                    onPressed: _clearAll,
                    child: Text(
                      context.tr(LocaleKeys.clearAll),
                      style: const TextStyle(color: AppColors.redColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              /// Category (from app categories API).
              Text(
                context.tr(LocaleKeys.chooseCategory),
                style: AppStyles.textStyle14W500White.copyWith(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (_loadingCats)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else if (_catsError != null && _categories.isEmpty)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _catsError!,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    TextButton(
                      onPressed: _loadCategories,
                      child: Text(context.tr(LocaleKeys.apply)),
                    ),
                  ],
                )
              else
                Builder(
                  builder: (context) {
                    final ids =
                        _categories.map((c) => c.id).toSet();
                    final safeCat =
                        ids.contains(_categoryId) ? _categoryId : null;
                    return DropdownButtonFormField<int>(
                      key: ValueKey('filter_cat_$safeCat'),
                      initialValue: safeCat,
                      items: _categories.map((c) {
                        return DropdownMenuItem<int>(
                          value: c.id,
                          child: Text(c.name ?? ''),
                        );
                      }).toList(),
                      onChanged: _onCategoryChanged,
                      decoration: _dropdownDecoration(
                        context.tr(LocaleKeys.chooseCategory),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 16),

              /// Sub-category (depends on selected category).
              Text(
                context.tr(LocaleKeys.chooseSubCategory),
                style: AppStyles.textStyle14W500White.copyWith(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (_categoryId == null)
                Text(
                  '-',
                  style: TextStyle(color: Colors.grey.shade500),
                )
              else if (_loadingSubs)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else if (_subCategories.isEmpty)
                Text(
                  '-',
                  style: TextStyle(color: Colors.grey.shade500),
                )
              else
                Builder(
                  builder: (context) {
                    final ids =
                        _subCategories.map((s) => s.id).toSet();
                    final safeSub =
                        ids.contains(_subCategoryId) ? _subCategoryId : null;
                    return DropdownButtonFormField<int>(
                      key: ValueKey('filter_sub_${_categoryId}_$safeSub'),
                      initialValue: safeSub,
                      items: _subCategories.map((s) {
                        return DropdownMenuItem<int>(
                          value: s.id,
                          child: Text(s.name ?? ''),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _subCategoryId = value);
                      },
                      decoration: _dropdownDecoration(
                        context.tr(LocaleKeys.chooseSubCategory),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 16),

              /// Type
              Text(
                context.tr(LocaleKeys.type),
                style: AppStyles.textStyle14W500White.copyWith(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (widget.availableTypes.isEmpty)
                Text(
                  '-',
                  style: TextStyle(color: Colors.grey.shade500),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _FilterChip(
                      label: context.tr(LocaleKeys.all),
                      selected: _type == null,
                      onSelected: () => setState(() => _type = null),
                    ),
                    ...widget.availableTypes.map(
                      (t) => _FilterChip(
                        label: t,
                        selected: _type == t,
                        onSelected: () => setState(() => _type = t),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),

              /// Price range
              Text(
                context.tr(LocaleKeys.price),
                style: AppStyles.textStyle14W500White.copyWith(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: _minController,
                      keyboardType: TextInputType.number,
                      labelText: context.tr(LocaleKeys.priceFrom),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextFormField(
                      controller: _maxController,
                      keyboardType: TextInputType.number,
                      labelText: context.tr(LocaleKeys.to),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// Place (governorate + center from shared cities list).
              /// Listens to ChooseLocationCubit so the dropdowns appear as
              /// soon as the data arrives — no need to reopen the sheet.
              Text(
                context.tr(LocaleKeys.place),
                style: AppStyles.textStyle14W500White.copyWith(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<ChooseLocationCubit, ChooseLocationStates>(
                builder: (context, state) {
                  final cities =
                      ChooseLocationCubit.get(context).allCitiesList;
                  if (cities.isEmpty) {
                    if (state is GetAllCitiesAndCentersLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }
                    if (state is GetAllCitiesAndCentersError) {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.message,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                          TextButton(
                            onPressed: () => ChooseLocationCubit.get(context)
                                .getAllCitiesAndCenters(),
                            child: Text(context.tr(LocaleKeys.apply)),
                          ),
                        ],
                      );
                    }
                    return Text(
                      '-',
                      style: TextStyle(color: Colors.grey.shade500),
                    );
                  }
                  final centers = _centersForCity(cities, _cityId);
                  final cityIds = cities.map((c) => c.id).toSet();
                  final safeCity =
                      cityIds.contains(_cityId) ? _cityId : null;
                  final centerIds = centers.map((c) => c.id).toSet();
                  final safeCenter =
                      centerIds.contains(_centerId) ? _centerId : null;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<int>(
                        key: ValueKey('city_$safeCity'),
                        initialValue: safeCity,
                        items: cities.map((city) {
                          return DropdownMenuItem<int>(
                            value: city.id,
                            child: Text(city.name ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _cityId = value;
                            // Reset center when the city changes.
                            _centerId = null;
                          });
                        },
                        decoration: _dropdownDecoration(
                          context.tr(LocaleKeys.chooseGovernment),
                        ),
                      ),
                      if (safeCity != null && centers.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          key: ValueKey('center_${safeCity}_$safeCenter'),
                          initialValue: safeCenter,
                          items: centers.map((center) {
                            return DropdownMenuItem<int>(
                              value: center.id,
                              child: Text(center.name ?? ''),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _centerId = value);
                          },
                          decoration: _dropdownDecoration(
                            context.tr(LocaleKeys.chooseCenter),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              /// Shipping type: both (no filter) / free / paid.
              Text(
                context.tr(LocaleKeys.chooseShippingType),
                style: AppStyles.textStyle14W500White.copyWith(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterChip(
                    label: context.tr(LocaleKeys.all),
                    selected: _shippingType == null,
                    onSelected: () => setState(() => _shippingType = null),
                  ),
                  _FilterChip(
                    label: context.tr(LocaleKeys.freeShipping),
                    selected: _shippingType == 'free',
                    onSelected: () => setState(() => _shippingType = 'free'),
                  ),
                  _FilterChip(
                    label: context.tr(LocaleKeys.paidShipping),
                    selected: _shippingType == 'paid',
                    onSelected: () => setState(() => _shippingType = 'paid'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// Condition: both (no filter) / new / used.
              Text(
                context.tr(LocaleKeys.chooseProductStatus),
                style: AppStyles.textStyle14W500White.copyWith(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterChip(
                    label: context.tr(LocaleKeys.all),
                    selected: _condition == null,
                    onSelected: () => setState(() => _condition = null),
                  ),
                  _FilterChip(
                    label: context.tr(LocaleKeys.conditionNew),
                    selected: _condition == 'new',
                    onSelected: () => setState(() => _condition = 'new'),
                  ),
                  _FilterChip(
                    label: context.tr(LocaleKeys.conditionUsed),
                    selected: _condition == 'used',
                    onSelected: () => setState(() => _condition = 'used'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CustomButton(
                btnText: Text(
                  context.tr(LocaleKeys.apply),
                  style: AppStyles.textStyle14W500White,
                ),
                onPressed: _apply,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.mainColor,
      backgroundColor: AppColors.grey2Color,
      labelStyle: TextStyle(
        color: selected ? AppColors.whiteColor : AppColors.blackColor,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? AppColors.mainColor : const Color(0xffD0D0D0),
        ),
      ),
      showCheckmark: false,
    );
  }
}
