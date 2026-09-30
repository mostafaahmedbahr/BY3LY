import 'package:by3ly/features/chooseLocation/data/models/cities_centers_model.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_cubit.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_states.dart';
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

  const ProductsFilter({
    this.type,
    this.minPrice,
    this.maxPrice,
    this.cityId,
    this.cityName,
    this.centerId,
    this.centerName,
  });

  const ProductsFilter.empty()
      : type = null,
        minPrice = null,
        maxPrice = null,
        cityId = null,
        cityName = null,
        centerId = null,
        centerName = null;

  bool get isEmpty =>
      type == null &&
      minPrice == null &&
      maxPrice == null &&
      cityId == null;

  int get activeCount =>
      (type != null ? 1 : 0) +
      (minPrice != null ? 1 : 0) +
      (maxPrice != null ? 1 : 0) +
      (cityId != null ? 1 : 0);

  /// Label shown on the active-filter chip, e.g. "القاهرة - مدينة نصر".
  String get placeLabel {
    if (cityName == null) return '';
    if (centerName != null) return '$cityName - $centerName';
    return cityName!;
  }
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
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

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
    Navigator.pop(
      context,
      ProductsFilter(
        type: _type,
        minPrice: double.tryParse(_minController.text.trim()),
        maxPrice: double.tryParse(_maxController.text.trim()),
        cityId: _cityId,
        cityName: cityName,
        centerId: _centerId,
        centerName: centerName,
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
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<int>(
                        key: ValueKey('city_$_cityId'),
                        initialValue: _cityId,
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
                      if (_cityId != null && centers.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          key: ValueKey('center_${_cityId}_$_centerId'),
                          initialValue: _centerId,
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
