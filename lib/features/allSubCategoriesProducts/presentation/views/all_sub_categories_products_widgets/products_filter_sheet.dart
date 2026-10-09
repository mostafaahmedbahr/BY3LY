import 'package:by3ly/features/allCategories/data/models/all_categoies_model.dart' as cats;
import 'package:by3ly/features/allSubCategories/data/models/all_sub_categories_model.dart' as subs;
import 'package:by3ly/features/allCategories/data/repositories/all_categories_repo_imple.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/cubit.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/states.dart';
import 'package:by3ly/features/allSubCategories/data/repos/all_sub_categories_repos_imple.dart';
import 'package:by3ly/features/allSubCategories/presentation/view_model/all_sub_categories_cubit.dart';
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

  /// Exact backend query keys (see products filter API):
  /// category_id, sub_category_id, min_price, max_price,
  /// city_id, center_id, shipping_type, condition.
  /// shipping_type / condition always sent (`both` = no filter).
  /// Numbers are sent as int when whole (100 not 100.0).
  Map<String, dynamic> toQueryParams() {
    final map = <String, dynamic>{};
    if (categoryId != null) map['category_id'] = categoryId;
    if (subCategoryId != null) map['sub_category_id'] = subCategoryId;
    if (minPrice != null) map['min_price'] = _cleanNum(minPrice!);
    if (maxPrice != null) map['max_price'] = _cleanNum(maxPrice!);
    if (cityId != null) map['city_id'] = cityId;
    if (centerId != null) map['center_id'] = centerId;
    map['shipping_type'] = shippingType ?? 'both';
    map['condition'] = condition ?? 'both';
    return map;
  }

  static dynamic _cleanNum(double v) =>
      v == v.roundToDouble() ? v.toInt() : v;

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
///
/// Categories / sub-categories are provided through their cubits so the
/// API is hit only once per session (static cache) no matter how many
/// times the sheet opens.
Future<ProductsFilter?> showProductsFilterSheet({
  required BuildContext context,
  required ProductsFilter initial,
  required List<String> availableTypes,
}) {
  return showModalBottomSheet<ProductsFilter>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xffF4F6F5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => MultiBlocProvider(
      providers: [
        // No auto-fetch here: _loadCategories() in initState drives the
        // single fetch (avoids two parallel network calls on open).
        BlocProvider(
          create: (_) => AllCategoriesCubit(
            getIt.get<AllCategoriesRepoImpl>(),
          ),
        ),
        BlocProvider(
          create: (_) => AllSubCategoriesCubit(
            getIt.get<AllSubCategoriesRepoImpl>(),
          ),
        ),
      ],
      child: ProductsFilterSheet(
        initial: initial,
        availableTypes: availableTypes,
      ),
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
    // Session cache first: no network call on reopen.
    final cachedCats =
        AllCategoriesCubit.cachedModel?.data?.categories ?? [];
    if (cachedCats.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        _loadingCats = false;
        _catsError = null;
        _categories = cachedCats;
      });
      if (_categoryId != null) _loadSubCategories(_categoryId!);
      return;
    }
    setState(() {
      _loadingCats = true;
      _catsError = null;
    });
    // Goes through the cubit so the result fills the session cache:
    // the API is hit only the first time per session.
    try {
      await context.read<AllCategoriesCubit>().getAllCategories();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingCats = false;
        _catsError = e.toString();
      });
      return;
    }
    if (!mounted) return;
    final cubit = context.read<AllCategoriesCubit>();
    final list = cubit.allCategoriesList;
    final state = cubit.state;
    setState(() {
      _loadingCats = false;
      _categories = list;
      _catsError =
          list.isEmpty && state is GetAllCategoriesError ? state.message : null;
    });
    // Load sub-categories if a category was pre-selected.
    if (_categoryId != null && list.any((c) => c.id == _categoryId)) {
      _loadSubCategories(_categoryId!);
    }
  }

  Future<void> _loadSubCategories(int categoryId) async {
    // Session cache first: no network call on reopen.
    final cachedSubs = AllSubCategoriesCubit.cachedFor(categoryId)
            ?.data
            ?.subCategories ??
        [];
    if (cachedSubs.isNotEmpty) {
      if (!mounted || _categoryId != categoryId) return;
      setState(() {
        _loadingSubs = false;
        _subCategories = cachedSubs;
      });
      return;
    }
    setState(() {
      _loadingSubs = true;
      _subCategories = [];
    });
    // Goes through the cubit so the result fills the session cache.
    try {
      await context
          .read<AllSubCategoriesCubit>()
          .getAllSubCategories(categoryId: categoryId);
    } catch (_) {
      if (!mounted || _categoryId != categoryId) return;
      setState(() => _loadingSubs = false);
      return;
    }
    // The user may have picked another category while loading:
    // ignore stale responses.
    if (!mounted || _categoryId != categoryId) return;
    setState(() {
      _loadingSubs = false;
      _subCategories =
          context.read<AllSubCategoriesCubit>().allSubCategoriesList;
    });
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

  /// Live count of what the user picked in this sheet opening.
  int get _activeCount =>
      (_categoryId != null ? 1 : 0) +
      (_subCategoryId != null ? 1 : 0) +
      (_type != null ? 1 : 0) +
      (_minController.text.trim().isNotEmpty ? 1 : 0) +
      (_maxController.text.trim().isNotEmpty ? 1 : 0) +
      (_cityId != null ? 1 : 0) +
      (_shippingType != null ? 1 : 0) +
      (_condition != null ? 1 : 0);

  bool get _hasSelection =>
      _activeCount > 0 ||
      _centerId != null;

  Widget _categoryField() {
    if (_loadingCats) {
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
    if (_catsError != null && _categories.isEmpty) {
      return Row(
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
      );
    }
    final ids = _categories.map((c) => c.id).toSet();
    final safeCat = ids.contains(_categoryId) ? _categoryId : null;
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
        prefix: const Icon(
          Icons.grid_view_rounded,
          color: AppColors.mainColor,
          size: 20,
        ),
      ),
    );
  }

  Widget _subCategoryField() {
    if (_categoryId == null) {
      return _DisabledHint(text: context.tr(LocaleKeys.chooseCategory));
    }
    if (_loadingSubs) {
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
    if (_subCategories.isEmpty) {
      return Text(
        '-',
        style: TextStyle(color: Colors.grey.shade500),
      );
    }
    final ids = _subCategories.map((s) => s.id).toSet();
    final safeSub = ids.contains(_subCategoryId) ? _subCategoryId : null;
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
        prefix: const Icon(
          Icons.account_tree_outlined,
          color: AppColors.mainColor,
          size: 20,
        ),
      ),
    );
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

  InputDecoration _dropdownDecoration(String label, {Widget? prefix}) {
    return InputDecoration(
      fillColor: const Color(0xffF8FAF9),
      filled: true,
      prefixIcon: prefix,
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.mainColor, fontSize: 13),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.mainColor, width: 1.2),
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
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xffE3E6E9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: AppColors.mainColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr(LocaleKeys.filter),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1F2937),
                          ),
                        ),
                        Text(
                          _activeCount == 0
                              ? context.tr(LocaleKeys.all)
                              : '$_activeCount ${context.tr(LocaleKeys.filter)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff9AA0A6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _hasSelection ? _clearAll : null,
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: Text(context.tr(LocaleKeys.clearAll)),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.redColor,
                      disabledForegroundColor:
                          const Color(0xffD0D0D0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              /// Category (from app categories API).
              _SectionCard(
                icon: Icons.grid_view_rounded,
                title: context.tr(LocaleKeys.chooseCategory),
                child: _categoryField(),
              ),
              const SizedBox(height: 12),

              /// Sub-category (depends on selected category).
              _SectionCard(
                icon: Icons.account_tree_outlined,
                title: context.tr(LocaleKeys.chooseSubCategory),
                child: _subCategoryField(),
              ),
              const SizedBox(height: 12),

              /// Type
              if (widget.availableTypes.isNotEmpty)
                _SectionCard(
                  icon: Icons.sell_outlined,
                  title: context.tr(LocaleKeys.type),
                  child: Wrap(
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
                ),
              if (widget.availableTypes.isNotEmpty)
                const SizedBox(height: 12),

              /// Price range
              _SectionCard(
                icon: Icons.payments_outlined,
                title: context.tr(LocaleKeys.price),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _minController,
                        keyboardType: TextInputType.number,
                        labelText: context.tr(LocaleKeys.priceFrom),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: 2,
                        width: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xffD0D0D0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _maxController,
                        keyboardType: TextInputType.number,
                        labelText: context.tr(LocaleKeys.to),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              /// Place (governorate + center from shared cities list).
              /// Listens to ChooseLocationCubit so the dropdowns appear as
              /// soon as the data arrives — no need to reopen the sheet.
              _SectionCard(
                icon: Icons.location_on_outlined,
                title: context.tr(LocaleKeys.place),
                child: BlocBuilder<ChooseLocationCubit, ChooseLocationStates>(
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
                          prefix: const Icon(
                            Icons.location_city_outlined,
                            color: AppColors.mainColor,
                            size: 20,
                          ),
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
                            prefix: const Icon(
                              Icons.my_location_outlined,
                              color: AppColors.mainColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
                ),
              ),
              const SizedBox(height: 12),

              /// Shipping type: both (no filter) / free / paid.
              _SectionCard(
                icon: Icons.local_shipping_outlined,
                title: context.tr(LocaleKeys.chooseShippingType),
                child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterChip(
                    icon: Icons.apps_rounded,
                    label: context.tr(LocaleKeys.all),
                    selected: _shippingType == null,
                    onSelected: () => setState(() => _shippingType = null),
                  ),
                  _FilterChip(
                    icon: Icons.local_shipping_outlined,
                    label: context.tr(LocaleKeys.freeShipping),
                    selected: _shippingType == 'free',
                    onSelected: () => setState(() => _shippingType = 'free'),
                  ),
                  _FilterChip(
                    icon: Icons.payments_outlined,
                    label: context.tr(LocaleKeys.paidShipping),
                    selected: _shippingType == 'paid',
                    onSelected: () => setState(() => _shippingType = 'paid'),
                  ),
                ],
                ),
              ),
              const SizedBox(height: 12),

              /// Condition: both (no filter) / new / used.
              _SectionCard(
                icon: Icons.verified_outlined,
                title: context.tr(LocaleKeys.chooseProductStatus),
                child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterChip(
                    icon: Icons.apps_rounded,
                    label: context.tr(LocaleKeys.all),
                    selected: _condition == null,
                    onSelected: () => setState(() => _condition = null),
                  ),
                  _FilterChip(
                    icon: Icons.fiber_new_rounded,
                    label: context.tr(LocaleKeys.conditionNew),
                    selected: _condition == 'new',
                    onSelected: () => setState(() => _condition = 'new'),
                  ),
                  _FilterChip(
                    icon: Icons.history_rounded,
                    label: context.tr(LocaleKeys.conditionUsed),
                    selected: _condition == 'used',
                    onSelected: () => setState(() => _condition = 'used'),
                  ),
                ],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                btnText: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _activeCount == 0
                          ? context.tr(LocaleKeys.apply)
                          : '${context.tr(LocaleKeys.apply)} ($_activeCount)',
                      style: AppStyles.textStyle14W500White.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                onPressed: _apply,
              ),
              const SizedBox(height: 8),
              ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.mainColor, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DisabledHint extends StatelessWidget {
  const _DisabledHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAF9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.5, color: Color(0xff9AA0A6)),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final content = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected
                    ? AppColors.whiteColor
                    : AppColors.mainColor,
              ),
              const SizedBox(width: 6),
              Text(label),
            ],
          );
    return ChoiceChip(
      label: content,
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.mainColor,
      backgroundColor: const Color(0xffF4F6F5),
      labelStyle: TextStyle(
        color: selected ? AppColors.whiteColor : const Color(0xff1F2937),
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: selected ? AppColors.mainColor : const Color(0xffE3E6E9),
          width: selected ? 1.2 : 1,
        ),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }
}
