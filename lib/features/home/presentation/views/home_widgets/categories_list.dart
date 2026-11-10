import 'package:by3ly/core/extensions/navigate.dart';
import 'package:by3ly/core/routing/routes.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../view_model/home_cubit.dart';
import '../../view_model/home_states.dart';
import 'categories_list_item.dart';
import 'section_header.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: context.tr(LocaleKeys.categories),
          actionLabel: context.tr(LocaleKeys.seeAll),
          onAction: () => context.pushNamed(Routes.allCategoriesView),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 92.h,
          child: BlocBuilder<HomeCubit, HomeStates>(
            builder: (context, state) {
              final homeCubit = context.read<HomeCubit>();
              final categories = homeCubit.homeModel?.data?.categories ?? [];
              if (categories.isEmpty) {
                return const SizedBox.shrink();
              }
              // Show first 5 only; the full list lives in the see-all page.
              final visible = categories.take(5).toList();
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) => CategoriesListItem(
                  id: visible[index].id ?? 0,
                  image: visible[index].image ?? '',
                  name: visible[index].name ?? '',
                ),
                separatorBuilder: (context, index) => const Gap(14),
                itemCount: visible.length,
              );
            },
          ),
        ),
      ],
    );
  }
}
