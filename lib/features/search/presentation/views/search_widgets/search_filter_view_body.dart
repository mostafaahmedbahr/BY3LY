import 'package:by3ly/core/shared_widgets/custom_sized_box.dart';
import 'package:by3ly/core/shared_widgets/custom_text_form_filed.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/search/data/models/category_model.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/shared_widgets/custom_button.dart';
import '../../../../../core/utils/app_styles/app_styles.dart';
import '../../view_model/search_cubit.dart';
import '../../view_model/search_states.dart';

class SearchFilterViewBody extends StatelessWidget {
  const SearchFilterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchStates>(
      builder: (context, state) {
        var searchCubit = SearchCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: searchCubit.selectedGovernorate,
                items: searchCubit.governorates
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  BlocProvider.of<SearchCubit>(context)
                      .selectGovernorate(value);
                },
                decoration: InputDecoration(
                  fillColor: AppColors.surface,
                  labelText: LocaleKeys.chooseGovernment.tr(),
                  labelStyle: TextStyle(
                    color: AppColors.accent,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (searchCubit.selectedGovernorate != null)
              DropdownButtonFormField<String>(
                value: searchCubit.selectedCenter,
                items: searchCubit.centers
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  BlocProvider.of<SearchCubit>(context).selectCenter(value);
                },
                decoration: InputDecoration(
                  fillColor: AppColors.surface,
                  labelText: LocaleKeys.chooseCenter.tr(),
                  labelStyle: TextStyle(
                    color: AppColors.accent,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                ),
              ),
              if (searchCubit.selectedGovernorate != null)
              const SizedBox(height: 20),

              DropdownButtonFormField<CategoryModel>(
                value: searchCubit.selectedCategory,
                items: searchCubit.categoriesAndSubCategories
                    .map((CategoryModel category) {
                  return DropdownMenuItem<CategoryModel>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  searchCubit.selectCategory(value);
                },
                decoration: InputDecoration(
                  fillColor: AppColors.surface,
                  labelText: LocaleKeys.chooseCategory.tr(),
                  labelStyle: TextStyle(
                    color: AppColors.accent,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (searchCubit.selectedCategory != null)
                DropdownButtonFormField<String>(
                  value: searchCubit.selectedSubCategory,
                  items: searchCubit.selectedCategory!.subCategories
                      .map((String subCategory) {
                    return DropdownMenuItem<String>(
                      value: subCategory,
                      child: Text(subCategory),
                    );
                  }).toList(),
                  onChanged: (value) {
                    searchCubit.selectSubCategory(value);
                  },
                  decoration: InputDecoration(
                    fillColor: AppColors.surface,
                    labelText: LocaleKeys.chooseSubCategory.tr(),
                    labelStyle: TextStyle(
                         color: AppColors.accent,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.border,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.border,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.border,
                      ),
                    ),
                  ),
                ),
              if (searchCubit.selectedCategory != null)
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: searchCubit.selectedShippingOption,
                items: searchCubit.shippingOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  searchCubit.selectShippingOption(value);
                },
                decoration: InputDecoration(
                  fillColor: AppColors.surface,
                  labelText: LocaleKeys.chooseShippingType.tr(),
                  labelStyle: TextStyle(
                    color: AppColors.accent,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                ),
              ),
              const CustomSizedBox(
                height: 20,
              ),

              DropdownButtonFormField<String>(
                value: searchCubit.selectedConditionOption,
                items: searchCubit.conditionOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  searchCubit.selectConditionOption(value);
                },
                decoration: InputDecoration(
                  fillColor: AppColors.surface,
                  labelText: LocaleKeys.chooseProductStatus.tr(),
                  labelStyle: TextStyle(
                    color: AppColors.accent,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                ),
              ),

              const CustomSizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: CustomTextFormField(
                    labelText: LocaleKeys.priceFrom.tr(),
                    keyboardType: TextInputType.number,
                  )),
                  const CustomSizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: CustomTextFormField(
                    labelText: LocaleKeys.to.tr(),
                    keyboardType: TextInputType.number,
                  )),
                ],
              ),
              const CustomSizedBox(
                height: 10,
              ),
              CustomButton(
                btnText:   Text(
                  LocaleKeys.search.tr(),
                  style: AppStyles.textStyle14W500White,
                ),
                onPressed: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   PageTransition(
                  //     type: PageTransitionType.fade,
                  //     child: const LayoutView(),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
