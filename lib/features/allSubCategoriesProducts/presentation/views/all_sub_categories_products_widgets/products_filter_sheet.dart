import 'package:by3ly/features/allCategories/data/models/all_categories_model.dart' as cats;
import 'package:by3ly/features/allSubCategories/data/models/all_sub_categories_model.dart' as subs;
import 'package:by3ly/features/allCategories/data/repos/all_categories_repo_imple.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/all_categories_cubit.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/all_categories_states.dart';
import 'package:by3ly/features/allSubCategories/data/repos/all_sub_categories_repos_imple.dart';
import 'package:by3ly/features/allSubCategories/presentation/view_model/all_sub_categories_cubit.dart';
import 'package:by3ly/features/chooseLocation/data/models/cities_centers_model.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_cubit.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_states.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/shared_widgets/custom_button.dart';
import 'filter_chip.dart';
import 'filter_disabled_hint.dart';
import 'filter_section_card.dart';
import 'products_filter.dart';
import '../../../../../core/shared_widgets/custom_text_form_filed.dart';
import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../../../../core/utils/app_styles/app_styles.dart';
import '../../../../../lang/locale_keys.dart';

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
    backgroundColor: AppColors.surfaceVariant,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      // Fixed sheet height (80% of the screen) so it never jumps
      // while dropdowns load; content is compacted to fit it.
      final sheetHeight =
          MediaQuery.of(sheetContext).size.height * 0.8;
      return MultiBlocProvider(
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
        child: SizedBox(
          height: sheetHeight,
          child: ProductsFilterSheet(
            initial: initial,
            availableTypes: availableTypes,
          ),
        ),
      );
    },
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
    // Default place = the user's own data (changeable below).
    // Only when the incoming filter has no place selected.
    if (_cityId == null) {
      try {
        final user =
            context.read<ProfileCubit>().profileModel?.data?.user;
        final profileCityId = _asInt(user?.cityId);
        if (profileCityId != null) {
          _cityId = profileCityId;
          _centerId ??= _asInt(user?.centerId);
        }
      } catch (_) {}
    }
    // If the shared cities list hasn't loaded yet (slow network on app
    // start), fetch it now so the dropdowns appear without reopening.
    final locationCubit = ChooseLocationCubit.get(context);
    if (locationCubit.allCitiesList.isEmpty) {
      locationCubit.getAllCitiesAndCenters();
    }
    _loadCategories();
  }

  int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
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
    // Close the sheet and reset any active filter.
    Navigator.pop(context, const ProductsFilter.empty());
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
              style: TextStyle(color: AppColors.textSecondary),
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
      isExpanded: true,
      items: _categories.map((c) {
        return DropdownMenuItem<int>(
          value: c.id,
          child: Text(
            c.name ?? '',
            overflow: TextOverflow.ellipsis,
          ),
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
      return FilterDisabledHint(text: context.tr(LocaleKeys.chooseSubCategory));
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
        style: TextStyle(color: AppColors.textSecondary),
      );
    }
    final ids = _subCategories.map((s) => s.id).toSet();
    final safeSub = ids.contains(_subCategoryId) ? _subCategoryId : null;
    return DropdownButtonFormField<int>(
      key: ValueKey('filter_sub_${_categoryId}_$safeSub'),
      initialValue: safeSub,
      isExpanded: true,
      items: _subCategories.map((s) {
        return DropdownMenuItem<int>(
          value: s.id,
          child: Text(
            s.name ?? '',
            overflow: TextOverflow.ellipsis,
          ),
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
    final filter = ProductsFilter(
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
    );
    // Nothing selected: just close, don't fire any filter call.
    if (filter.isEmpty && _centerId == null) {
      Navigator.pop(context);
      return;
    }
    Navigator.pop(context, filter);
  }

  InputDecoration _dropdownDecoration(String label, {Widget? prefix}) {
    return InputDecoration(
      fillColor: AppColors.surfaceVariant,
      filled: true,
      prefixIcon: prefix,
      labelText: label,
      labelStyle: TextStyle(color: AppColors.accent, fontSize: 12),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: AppColors.mainColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr(LocaleKeys.filter),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          _activeCount == 0
                              ? context.tr(LocaleKeys.all)
                              : '$_activeCount ${context.tr(LocaleKeys.filter)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
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
                          AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// Category + sub-category side by side (related fields).
              FilterSectionCard(
                icon: Icons.grid_view_rounded,
                title: context.tr(LocaleKeys.chooseCategory),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _categoryField()),
                    const SizedBox(width: 10),
                    Expanded(child: _subCategoryField()),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              /// Type
              if (widget.availableTypes.isNotEmpty)
                FilterSectionCard(
                  icon: Icons.sell_outlined,
                  title: context.tr(LocaleKeys.type),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterOptionChip(
                        label: context.tr(LocaleKeys.all),
                        selected: _type == null,
                        onSelected: () => setState(() => _type = null),
                      ),
                      ...widget.availableTypes.map(
                        (t) => FilterOptionChip(
                          label: t,
                          selected: _type == t,
                          onSelected: () => setState(() => _type = t),
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.availableTypes.isNotEmpty)
                const SizedBox(height: 8),

              /// Price range
              FilterSectionCard(
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
                          color: AppColors.border,
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
              const SizedBox(height: 8),

              /// Place (governorate + center from shared cities list).
              /// Listens to ChooseLocationCubit so the dropdowns appear as
              /// soon as the data arrives — no need to reopen the sheet.
              FilterSectionCard(
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
                              style: TextStyle(color: AppColors.textSecondary),
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
                      style: TextStyle(color: AppColors.textSecondary),
                    );
                  }
                  final centers = _centersForCity(cities, _cityId);
                  final cityIds = cities.map((c) => c.id).toSet();
                  final safeCity =
                      cityIds.contains(_cityId) ? _cityId : null;
                  final centerIds = centers.map((c) => c.id).toSet();
                  final safeCenter =
                      centerIds.contains(_centerId) ? _centerId : null;
                  // City + center side by side (related fields).
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          key: ValueKey('city_$safeCity'),
                          initialValue: safeCity,
                          isExpanded: true,
                          items: cities.map((city) {
                            return DropdownMenuItem<int>(
                              value: city.id,
                              child: Text(
                                city.name ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
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
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: (safeCity == null || centers.isEmpty)
                            ? DropdownButtonFormField<int>(
                                items: const [],
                                onChanged: null,
                                decoration: _dropdownDecoration(
                                  context.tr(LocaleKeys.chooseCenter),
                                  prefix: const Icon(
                                    Icons.my_location_outlined,
                                    color: AppColors.mainColor,
                                    size: 20,
                                  ),
                                ),
                              )
                            : DropdownButtonFormField<int>(
                                key: ValueKey(
                                    'center_${safeCity}_$safeCenter'),
                                initialValue: safeCenter,
                                isExpanded: true,
                                items: centers.map((center) {
                                  return DropdownMenuItem<int>(
                                    value: center.id,
                                    child: Text(
                                      center.name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                      ),
                    ],
                  );
                },
                ),
              ),
              const SizedBox(height: 8),

              /// Shipping type: both (no filter) / free / paid.
              FilterSectionCard(
                icon: Icons.local_shipping_outlined,
                title: context.tr(LocaleKeys.chooseShippingType),
                child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterOptionChip(
                    icon: Icons.apps_rounded,
                    label: context.tr(LocaleKeys.all),
                    selected: _shippingType == null,
                    onSelected: () => setState(() => _shippingType = null),
                  ),
                  FilterOptionChip(
                    icon: Icons.local_shipping_outlined,
                    label: context.tr(LocaleKeys.freeShipping),
                    selected: _shippingType == 'free',
                    onSelected: () => setState(() => _shippingType = 'free'),
                  ),
                  FilterOptionChip(
                    icon: Icons.payments_outlined,
                    label: context.tr(LocaleKeys.paidShipping),
                    selected: _shippingType == 'paid',
                    onSelected: () => setState(() => _shippingType = 'paid'),
                  ),
                ],
                ),
              ),
              const SizedBox(height: 8),

              /// Condition: both (no filter) / new / used.
              FilterSectionCard(
                icon: Icons.verified_outlined,
                title: context.tr(LocaleKeys.chooseProductStatus),
                child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterOptionChip(
                    icon: Icons.apps_rounded,
                    label: context.tr(LocaleKeys.all),
                    selected: _condition == null,
                    onSelected: () => setState(() => _condition = null),
                  ),
                  FilterOptionChip(
                    icon: Icons.fiber_new_rounded,
                    label: context.tr(LocaleKeys.conditionNew),
                    selected: _condition == 'new',
                    onSelected: () => setState(() => _condition = 'new'),
                  ),
                  FilterOptionChip(
                    icon: Icons.history_rounded,
                    label: context.tr(LocaleKeys.conditionUsed),
                    selected: _condition == 'used',
                    onSelected: () => setState(() => _condition = 'used'),
                  ),
                ],
                ),
              ),
              const SizedBox(height: 10),
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

