import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../core/shared_widgets/container_search_widget.dart';
import '../../../../../core/shared_widgets/shimmer_loading.dart';
import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../../../../core/utils/app_styles/app_styles.dart';
import '../../../../../lang/locale_keys.dart';
import '../../../../allCategories/presentation/views/all_categories_view.dart';
import '../../../../seeAllBestView/presentation/views/see_all_best_view.dart';

class HomeLoadingWidget extends StatelessWidget {
  const HomeLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        /// search
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: ContainerSearchWidget(),
        ),
        /// CategoriesList
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr(LocaleKeys.categories),
                    style: AppStyles.textStyle16W600Black,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: const AllCategoriesView(),
                        ),
                      );
                    },
                    child: Text(
                      context.tr(LocaleKeys.seeAll),
                      style: const TextStyle(color: AppColors.mainColor),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return const SimmerLoading(
                      height: 70,
                      width: 70,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 25,
                    );
                  },
                  itemCount: 10,
                ),
              )
            ],
          ),
        ),
        ///BannerToLogin
        const SimmerLoading(
          height: 100,
        ),
        const SizedBox(
          height: 10,
        ),
        ///BannerAds1
        SizedBox(
          height: 140,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return const SimmerLoading(
                raduis: 10,
                height: 140,
              );
            },
            itemCount: 3,
            viewportFraction: 0.8,
            scale: 0.9,
            pagination: const SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                activeColor: AppColors
                    .mainColor, // Change this to your desired active color
              ),
              margin: EdgeInsets.all(10.0),
            ),
            autoplay: true,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        /// bestView
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20, left: 20, right: 20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.tr(LocaleKeys.bestView),
                    style: AppStyles.textStyle16W600Black,),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: const SeeAllView(),
                        ),
                      );
                    },
                    child: Text(context.tr(LocaleKeys.seeAll),
                      style: const TextStyle(
                          color: AppColors.mainColor
                      ),),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.7,
                ),
                itemCount: 20,
                itemBuilder: (context, index) {
                  return const SimmerLoading(
                    height: 120,
                    raduis: 10,
                  );
                },
              )
            ],
          ),
        ),
        ///BannerAds2
        SizedBox(
          height: 140,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return const SimmerLoading(
                raduis: 10,
                height: 140,
              );
            },
            itemCount: 3,
            viewportFraction: 0.8,
            scale: 0.9,
            pagination: const SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                activeColor: AppColors
                    .mainColor, // Change this to your desired active color
              ),
              margin: EdgeInsets.all(10.0),
            ),
            autoplay: true,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ///BannerAds3
        SizedBox(
          height: 140,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return const SimmerLoading(
                raduis: 10,
                height: 140,
              );
            },
            itemCount: 3,
            viewportFraction: 0.8,
            scale: 0.9,
            pagination: const SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                activeColor: AppColors
                    .mainColor, // Change this to your desired active color
              ),
              margin: EdgeInsets.all(10.0),
            ),
            autoplay: true,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
