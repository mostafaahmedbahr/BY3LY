import 'dart:io';

import 'package:by3ly/core/shared_widgets/custom_button.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/app_styles/app_styles.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_cubit.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_new_ad_states.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/cubit.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/states.dart';
import 'package:by3ly/features/allSubCategories/presentation/view_model/all_sub_categories_cubit.dart';
import 'package:by3ly/features/allSubCategories/presentation/view_model/all_sub_categories_states.dart';
import 'package:by3ly/features/chooseLocation/data/models/cities_centers_model.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewAdViewBody extends StatefulWidget {
  const AddNewAdViewBody({super.key, this.adToEdit});

  /// When set, the form works in edit mode pre-filled from this ad.
  final dynamic adToEdit;

  @override
  State<AddNewAdViewBody> createState() => _AddNewAdViewBodyState();
}

class _AddNewAdViewBodyState extends State<AddNewAdViewBody> {
  @override
  void initState() {
    super.initState();
    final cubit = AddNewAdCubit.get(context);
    final user =
        ProfileCubit.get(context).profileModel?.data?.user;
    final ad = widget.adToEdit;
    if (ad != null) {
      cubit.fillForEdit(
        adId: ad.id ?? 0,
        name: ad.name?.toString(),
        description:
            (ad.desc?.toString().trim().isNotEmpty ?? false)
                ? ad.desc?.toString()
                : ad.description?.toString(),
        price: ad.price?.toString(),
        discount: ad.discount?.toString(),
        negotiable: ad.isNegotiable == true ? 1 : 0,
        urgent: ad.isUrgent == true ? 1 : 0,
        categoryId: _asInt(ad.categoryId),
        subCategoryId: _asInt(ad.subCategoryId),
        shipping: ad.shippingType?.toString(),
        conditionValue: ad.condition?.toString(),
        cityIdValue: _asInt(ad.cityId),
        centerIdValue: _asInt(ad.centerId),
        imageUrls: [
          for (final img in (ad.images ?? []))
            if ((img?.image?.trim().isNotEmpty ?? false))
              img!.image!.trim(),
        ],
        profileCityId: _asInt(user?.cityId),
        profileCenterId: _asInt(user?.centerId),
      );
      // Load sub-categories of the ad's category for the dropdown.
      final catId = _asInt(ad.categoryId);
      if (catId != null) {
        AllSubCategoriesCubit.get(context)
            .getAllSubCategories(categoryId: catId);
      }
    } else {
      // Default city/center = the user's own data (changeable below).
      cubit.initLocation(
        defaultCityId: _asInt(user?.cityId),
        defaultCenterId: _asInt(user?.centerId),
      );
    }
  }

  int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  String _validationMessage(String key) {
    switch (key) {
      case 'imagesRequired':
        return context.tr(LocaleKeys.imagesRequired);
      case 'nameRequired':
        return context.tr(LocaleKeys.nameRequired);
      case 'descRequired':
        return context.tr(LocaleKeys.descRequired);
      case 'priceRequired':
        return context.tr(LocaleKeys.priceRequired);
      case 'categoryRequired':
        return context.tr(LocaleKeys.categoryRequired);
      case 'subCategoryRequired':
        return context.tr(LocaleKeys.subCategoryRequired);
      case 'cityRequired':
        return context.tr(LocaleKeys.cityRequired);
      case 'centerRequired':
        return context.tr(LocaleKeys.centerRequired);
      default:
        return key;
    }
  }

  InputDecoration _dropdownDecoration(String label, {Widget? prefix}) {
    return InputDecoration(
      fillColor: const Color(0xffF8FAF9),
      filled: true,
      prefixIcon: prefix,
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.mainColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.mainColor),
      ),
    );
  }

  Future<void> _showImageSourceSheet(
      BuildContext context, AddNewAdCubit cubit) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SourceOption(
                      icon: Icons.photo_camera_outlined,
                      label: context.tr(LocaleKeys.uploadImageFromCamera),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        cubit.pickFromCamera(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SourceOption(
                      icon: Icons.photo_library_outlined,
                      label: context.tr(LocaleKeys.uploadImageFromGallery),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        cubit.pickImages(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNewAdCubit, AddNewAdStates>(
      listener: (context, state) {
        if (state is AddNewAdSuccess) {
          CherryToast.success(
            title: Text(
              (state.message?.trim().isNotEmpty ?? false)
                  ? state.message!
                  : context.tr(LocaleKeys.publishAd),
              style:
                  const TextStyle(color: AppColors.mainColor),
            ),
          ).show(context);
          Navigator.pop(context, true);
        } else if (state is AddNewAdError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final cubit = AddNewAdCubit.get(context);
        final submitting = state is AddNewAdLoading;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _FormCard(
              step: '1',
              title: context.tr(LocaleKeys.selectImages),
              child: _ImagesPicker(
                  onAdd: () => _showImageSourceSheet(context, cubit)),
            ),
            _FormCard(
              step: '2',
              title: context.tr(LocaleKeys.adName),
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: cubit.nameCon,
                    keyboardType: TextInputType.text,
                    labelText: context.tr(LocaleKeys.adName),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.title_rounded,
                          color: AppColors.mainColor, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    controller: cubit.descCon,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    labelText: context.tr(LocaleKeys.adDescription),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.description_outlined,
                          color: AppColors.mainColor, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: cubit.priceCon,
                          keyboardType: TextInputType.number,
                          labelText: context.tr(LocaleKeys.adPrice),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.payments_outlined,
                                color: AppColors.mainColor,
                                size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextFormField(
                          controller: cubit.discountCon,
                          keyboardType: TextInputType.number,
                          labelText:
                              context.tr(LocaleKeys.discount),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.percent_rounded,
                                color: AppColors.mainColor,
                                size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _SwitchRow(
                    title: context.tr(LocaleKeys.negotiable),
                    icon: Icons.handshake_outlined,
                    value: cubit.isNegotiable == 1,
                    onChanged: cubit.toggleNegotiable,
                  ),
                  const SizedBox(height: 8),
                  _SwitchRow(
                    title: context.tr(LocaleKeys.urgent),
                    icon: Icons.bolt_outlined,
                    value: cubit.isUrgent == 1,
                    onChanged: cubit.toggleUrgent,
                  ),
                ],
              ),
            ),
            _FormCard(
              step: '3',
              title: context.tr(LocaleKeys.category),
              child: Column(
                children: [
                  _CategoryDropdown(decoration: _dropdownDecoration),
                  const SizedBox(height: 12),
                  _SubCategoryDropdown(
                      decoration: _dropdownDecoration),
                ],
              ),
            ),
            _FormCard(
              step: '4',
              title: context.tr(LocaleKeys.shippingType),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ChipsRow(
                    options: [
                      _ChipOption(
                          value: 'free',
                          label:
                              context.tr(LocaleKeys.freeShipping)),
                      _ChipOption(
                          value: 'paid',
                          label:
                              context.tr(LocaleKeys.paidShipping)),
                    ],
                    selected: cubit.shippingType,
                    onSelected: cubit.selectShipping,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.tr(LocaleKeys.condition),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ChipsRow(
                    options: [
                      _ChipOption(
                          value: 'new',
                          label:
                              context.tr(LocaleKeys.conditionNew)),
                      _ChipOption(
                          value: 'used',
                          label: context
                              .tr(LocaleKeys.conditionUsed)),
                    ],
                    selected: cubit.condition,
                    onSelected: cubit.selectCondition,
                  ),
                ],
              ),
            ),
            _FormCard(
              step: '5',
              title: context.tr(LocaleKeys.place),
              child: Column(
                children: [
                  _CityDropdown(decoration: _dropdownDecoration),
                  const SizedBox(height: 12),
                  _CenterDropdown(decoration: _dropdownDecoration),
                ],
              ),
            ),
            CustomButton(
              btnText: submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cubit.isEditMode
                              ? context.tr(LocaleKeys.editAd)
                              : context.tr(LocaleKeys.publishAd),
                          style: AppStyles.textStyle14W500White.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          cubit.isEditMode
                              ? Icons.edit_outlined
                              : Icons.rocket_launch_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
              onPressed: submitting
                  ? () {}
                  : () {
                      final error = cubit.validate();
                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  _validationMessage(error))),
                        );
                        return;
                      }
                      if (cubit.isEditMode) {
                        cubit.submitEdit();
                      } else {
                        cubit.submit();
                      }
                    },
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

/// Numbered white section card.
class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.step,
    required this.title,
    required this.child,
  });

  final String step;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        children: [
          Row(
            children: [
              Container(
                height: 26,
                width: 26,
                decoration: const BoxDecoration(
                  color: AppColors.mainColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    step,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
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

class _SourceOption extends StatelessWidget {
  const _SourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xffF8FAF9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Column(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.mainColor,
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xff1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagesPicker extends StatelessWidget {
  const _ImagesPicker({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewAdCubit, AddNewAdStates>(
      builder: (context, state) {
        final cubit = AddNewAdCubit.get(context);
        return SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cubit.existingImages.length +
                cubit.images.length +
                1,
            separatorBuilder: (context, _) =>
                const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final existingCount = cubit.existingImages.length;
              // Existing network images, then newly picked files,
              // then the add tile.
              if (index < existingCount) {
                final url = cubit.existingImages[index];
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        url,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 100,
                          height: 100,
                          color: const Color(0xffF1F3F5),
                          child: const Icon(
                              Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: InkWell(
                        onTap: () =>
                            cubit.removeExistingImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.redColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color:
                              Colors.black.withValues(alpha: 0.55),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              final fileIndex = index - existingCount;
              if (fileIndex < cubit.images.length) {
                final file = cubit.images[fileIndex];
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        File(file.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: InkWell(
                        onTap: () =>
                            cubit.removeImage(fileIndex),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.redColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color:
                              Colors.black.withValues(alpha: 0.55),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              final full =
                  cubit.totalImagesCount >= AddNewAdCubit.maxImages;
              return InkWell(
                onTap: full ? null : onAdd,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xffF8FAF9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.mainColor
                          .withValues(alpha: 0.4),
                      style: BorderStyle.solid,
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: full
                            ? Colors.grey.shade400
                            : AppColors.mainColor,
                        size: 26,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${cubit.totalImagesCount}/${AddNewAdCubit.maxImages}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: full
                              ? Colors.grey.shade400
                              : AppColors.mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: value
            ? AppColors.mainColor.withValues(alpha: 0.07)
            : const Color(0xffF8FAF9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? AppColors.mainColor : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 20,
              color: value
                  ? AppColors.mainColor
                  : const Color(0xff9AA0A6)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: value
                    ? AppColors.mainColor
                    : const Color(0xff1F2937),
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.mainColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({required this.decoration});

  final InputDecoration Function(String, {Widget? prefix}) decoration;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewAdCubit, AddNewAdStates>(
      builder: (context, adState) {
        final adCubit = AddNewAdCubit.get(context);
        return BlocBuilder<AllCategoriesCubit, AllCategoriesStates>(
          builder: (context, state) {
            if (state is GetAllCategoriesLoading) {
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
            final categories = context
                    .read<AllCategoriesCubit>()
                    .allCategoriesModel
                    ?.data
                    ?.categories ??
                [];
            return DropdownButtonFormField<int>(
              key: ValueKey('cat_${adCubit.categoryId}'),
              initialValue: adCubit.categoryId,
              items: categories.map((c) {
                return DropdownMenuItem<int>(
                  value: c.id,
                  child: Text(c.name ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                adCubit.selectCategory(value);
                AllSubCategoriesCubit.get(context)
                    .getAllSubCategories(categoryId: value);
              },
              decoration: decoration(
                context.tr(LocaleKeys.category),
                prefix: const Icon(Icons.grid_view_rounded,
                    color: AppColors.mainColor, size: 20),
              ),
            );
          },
        );
      },
    );
  }
}

class _SubCategoryDropdown extends StatelessWidget {
  const _SubCategoryDropdown({required this.decoration});

  final InputDecoration Function(String, {Widget? prefix}) decoration;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewAdCubit, AddNewAdStates>(
      builder: (context, adState) {
        final adCubit = AddNewAdCubit.get(context);
        if (adCubit.categoryId == null) {
          return DropdownButtonFormField<int>(
            items: const [],
            onChanged: null,
            decoration: decoration(
              context.tr(LocaleKeys.subCategory),
              prefix: const Icon(Icons.account_tree_outlined,
                  color: AppColors.mainColor, size: 20),
            ),
          );
        }
        return BlocBuilder<AllSubCategoriesCubit,
            AllSubCategoriesStates>(
          builder: (context, state) {
            if (state is GetAllSubCategoriesLoading) {
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
            final subs = AllSubCategoriesCubit.get(context)
                    .allSubCategoriesModel
                    ?.data
                    ?.subCategories ??
                [];
            return DropdownButtonFormField<int>(
              key: ValueKey(
                  'sub_${adCubit.categoryId}_${adCubit.subCategoryId}'),
              initialValue: adCubit.subCategoryId,
              items: subs.map((s) {
                return DropdownMenuItem<int>(
                  value: s.id,
                  child: Text(s.name ?? ''),
                );
              }).toList(),
              onChanged: adCubit.selectSubCategory,
              decoration: decoration(
                context.tr(LocaleKeys.subCategory),
                prefix: const Icon(Icons.account_tree_outlined,
                    color: AppColors.mainColor, size: 20),
              ),
            );
          },
        );
      },
    );
  }
}

class _CityDropdown extends StatelessWidget {
  const _CityDropdown({required this.decoration});

  final InputDecoration Function(String, {Widget? prefix}) decoration;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewAdCubit, AddNewAdStates>(
      builder: (context, adState) {
        final adCubit = AddNewAdCubit.get(context);
        final cities =
            ChooseLocationCubit.get(context).allCitiesList;
        if (cities.isEmpty) {
          return DropdownButtonFormField<int>(
            items: const [],
            onChanged: null,
            decoration: decoration(
              context.tr(LocaleKeys.city),
              prefix: const Icon(Icons.location_city_outlined,
                  color: AppColors.mainColor, size: 20),
            ),
          );
        }
        return DropdownButtonFormField<int>(
          key: ValueKey('city_${adCubit.cityId}'),
          initialValue: adCubit.cityId,
          items: cities.map((city) {
            return DropdownMenuItem<int>(
              value: city.id,
              child: Text(city.name ?? ''),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) return;
            adCubit.selectCity(value);
          },
          decoration: decoration(
            context.tr(LocaleKeys.city),
            prefix: const Icon(Icons.location_city_outlined,
                color: AppColors.mainColor, size: 20),
          ),
        );
      },
    );
  }
}

class _CenterDropdown extends StatelessWidget {
  const _CenterDropdown({required this.decoration});

  final InputDecoration Function(String, {Widget? prefix}) decoration;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewAdCubit, AddNewAdStates>(
      builder: (context, adState) {
        final adCubit = AddNewAdCubit.get(context);
        final cities =
            ChooseLocationCubit.get(context).allCitiesList;
        List<Centers> centers = [];
        for (final city in cities) {
          if (city.id == adCubit.cityId) {
            centers = city.centers ?? [];
            break;
          }
        }
        if (adCubit.cityId == null || centers.isEmpty) {
          return DropdownButtonFormField<int>(
            items: const [],
            onChanged: null,
            decoration: decoration(
              context.tr(LocaleKeys.center),
              prefix: const Icon(Icons.my_location_outlined,
                  color: AppColors.mainColor, size: 20),
            ),
          );
        }
        return DropdownButtonFormField<int>(
          key: ValueKey(
              'center_${adCubit.cityId}_${adCubit.centerId}'),
          initialValue: adCubit.centerId,
          items: centers.map((c) {
            return DropdownMenuItem<int>(
              value: c.id,
              child: Text(c.name ?? ''),
            );
          }).toList(),
          onChanged: adCubit.selectCenter,
          decoration: decoration(
            context.tr(LocaleKeys.center),
            prefix: const Icon(Icons.my_location_outlined,
                color: AppColors.mainColor, size: 20),
          ),
        );
      },
    );
  }
}

class _ChipOption {
  final String value;
  final String label;

  const _ChipOption({required this.value, required this.label});
}

class _ChipsRow extends StatelessWidget {
  const _ChipsRow({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<_ChipOption> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options
          .map(
            (o) => ChoiceChip(
              label: Text(o.label),
              selected: selected == o.value,
              onSelected: (_) => onSelected(o.value),
              selectedColor: AppColors.mainColor,
              backgroundColor: const Color(0xffF1F3F5),
              labelStyle: TextStyle(
                color: selected == o.value
                    ? Colors.white
                    : const Color(0xff1F2937),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: selected == o.value
                      ? AppColors.mainColor
                      : const Color(0xffD0D0D0),
                ),
              ),
              showCheckmark: false,
            ),
          )
          .toList(),
    );
  }
}
