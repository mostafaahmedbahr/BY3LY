import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/allSubCategories/data/models/all_sub_categories_model.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/core/extensions/navigate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive 2-column grid of sub-sections with product counts.
/// Tapping a section opens its products screen.
class AllSubCategoriesList extends StatelessWidget {
  const AllSubCategoriesList({
    super.key,
    required this.allSubCategoriesList,
    required this.categoryId,
  });

  final List<SubCategories> allSubCategoriesList;
  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 2.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.76,
      ),
      itemCount: allSubCategoriesList.length,
      itemBuilder: (context, index) {
        final item = allSubCategoriesList[index];
        final isEmpty = (item.productsCount ?? 0) == 0;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22.r),
            onTap: () {
              if (isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.tr(LocaleKeys.noProductsInSection),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              final subCategoryId = item.id;
              if (subCategoryId == null) return;
              context.pushNamed(
                Routes.allSubCategoriesProductsView,
                arguments: {
                  "subCategoryId": subCategoryId,
                  "subCategoryName": item.name.toString(),
                },
              );
            },
            child: Ink(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mainColor.withValues(alpha: 0.10),
                    blurRadius: 18,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(9.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with the products-count badge.
                    Expanded(
                      flex: 7,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(17.r),
                              child: CachedNetworkImage(
                                imageUrl: item.image ?? '',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.mainColor.withValues(
                                    alpha: 0.07,
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Container(
                                      color: AppColors.mainColor.withValues(
                                        alpha: 0.07,
                                      ),
                                      child: Icon(
                                        Icons.category_rounded,
                                        size: 45.sp,
                                        color: AppColors.mainColor,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 9.h,
                            right: 9.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 9.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.95),
                                borderRadius: BorderRadius.circular(30.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: 0.08,
                                    ),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 12.sp,
                                    color: AppColors.mainColor,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${item.productsCount ?? 0}',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Name + arrow.
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: AppColors.mainColor,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 5.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        context.tr(LocaleKeys.discoverProducts),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
